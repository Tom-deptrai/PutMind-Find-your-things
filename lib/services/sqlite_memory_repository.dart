import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/memory.dart';
import 'memory_repository.dart';

/// Persistent SQLite repository with FTS for transcript search.
class SqliteMemoryRepository implements MemoryRepository {
  SqliteMemoryRepository._(this._db);

  final Database _db;

  static const _dbName = 'putmind_memories.db';

  /// v1: single image_path. v2: image_paths JSON (+ legacy image_path cover).
  static const _dbVersion = 2;

  /// Opens (or creates) the app database under [databasesPath].
  static Future<SqliteMemoryRepository> open({
    String? databasesPath,
    String fileName = _dbName,
  }) async {
    final base = databasesPath ?? await getDatabasesPath();
    final path = p.join(base, fileName);
    final db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return SqliteMemoryRepository._(db);
  }

  /// Opens an in-memory SQLite DB (tests).
  static Future<SqliteMemoryRepository> openInMemory() async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return SqliteMemoryRepository._(db);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memories (
        id TEXT PRIMARY KEY NOT NULL,
        transcript TEXT NOT NULL,
        image_path TEXT,
        image_paths TEXT NOT NULL DEFAULT '[]',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE VIRTUAL TABLE memories_fts USING fts4(
        id,
        transcript,
        tokenize=porter
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_memories_updated_at ON memories(updated_at DESC)',
    );
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE memories ADD COLUMN image_paths TEXT NOT NULL DEFAULT '[]'",
      );
      // Migrate legacy single image_path → JSON list of one.
      final rows = await db.query('memories', columns: ['id', 'image_path']);
      for (final row in rows) {
        final id = row['id']! as String;
        final single = row['image_path'] as String?;
        final paths = (single == null || single.isEmpty)
            ? <String>[]
            : <String>[single];
        await db.update(
          'memories',
          {'image_paths': jsonEncode(paths)},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
  }

  @override
  Future<List<Memory>> getAll() async {
    final rows = await _db.query('memories', orderBy: 'updated_at DESC');
    return rows.map(Memory.fromMap).toList(growable: false);
  }

  @override
  Future<Memory?> getById(String id) async {
    final rows = await _db.query(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Memory.fromMap(rows.first);
  }

  @override
  Future<void> upsert(Memory memory) async {
    await _db.transaction((txn) async {
      await txn.insert(
        'memories',
        memory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.delete('memories_fts', where: 'id = ?', whereArgs: [memory.id]);
      await txn.insert('memories_fts', {
        'id': memory.id,
        'transcript': memory.transcript,
      });
    });
  }

  @override
  Future<void> delete(String id) async {
    await _db.transaction((txn) async {
      await txn.delete('memories', where: 'id = ?', whereArgs: [id]);
      await txn.delete('memories_fts', where: 'id = ?', whereArgs: [id]);
    });
  }

  @override
  Future<List<Memory>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return getAll();

    final sanitized = q.replaceAll('"', '""');
    final ftsQuery = '"$sanitized"*';

    List<Map<String, Object?>> rows;
    try {
      rows = await _db.rawQuery(
        '''
        SELECT m.*
        FROM memories m
        INNER JOIN memories_fts f ON m.id = f.id
        WHERE memories_fts MATCH ?
        ORDER BY m.updated_at DESC
        ''',
        [ftsQuery],
      );
    } catch (_) {
      rows = const [];
    }

    if (rows.isEmpty) {
      rows = await _db.query(
        'memories',
        where: 'LOWER(transcript) LIKE ?',
        whereArgs: ['%${q.toLowerCase()}%'],
        orderBy: 'updated_at DESC',
      );
    }

    final memories = rows.map(Memory.fromMap).toList();

    final lower = q.toLowerCase();
    memories.sort((a, b) {
      final aScore = a.transcript.toLowerCase().contains(lower) ? 2 : 1;
      final bScore = b.transcript.toLowerCase().contains(lower) ? 2 : 1;
      final byScore = bScore.compareTo(aScore);
      if (byScore != 0) return byScore;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return memories;
  }

  @override
  Future<void> replaceAll(List<Memory> memories) async {
    await _db.transaction((txn) async {
      await txn.delete('memories');
      await txn.delete('memories_fts');
      for (final memory in memories) {
        await txn.insert('memories', memory.toMap());
        await txn.insert('memories_fts', {
          'id': memory.id,
          'transcript': memory.transcript,
        });
      }
    });
  }

  @override
  Future<void> clear() async {
    await _db.transaction((txn) async {
      await txn.delete('memories');
      await txn.delete('memories_fts');
    });
  }

  @override
  Future<void> close() => _db.close();
}
