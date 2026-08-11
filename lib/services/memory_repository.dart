import '../models/memory.dart';

/// Free tier memory limit (Product Spec §31).
const int kFreeMemoryLimit = 20;

/// Contract for memory persistence.
///
/// UI/state talk only to this abstraction — never SQLite directly.
abstract class MemoryRepository {
  Future<List<Memory>> getAll();

  Future<Memory?> getById(String id);

  Future<void> upsert(Memory memory);

  Future<void> delete(String id);

  /// Case-insensitive partial transcript search.
  ///
  /// Results ordered by relevance, then newest first.
  Future<List<Memory>> search(String query);

  Future<void> replaceAll(List<Memory> memories);

  Future<void> clear();

  Future<void> close();
}

/// In-memory implementation used by tests and Flutter Web preview.
class InMemoryMemoryRepository implements MemoryRepository {
  InMemoryMemoryRepository({List<Memory>? seed}) : _memories = [...?seed];

  final List<Memory> _memories;

  @override
  Future<List<Memory>> getAll() async {
    final all = [..._memories];
    all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(all);
  }

  @override
  Future<Memory?> getById(String id) async {
    for (final m in _memories) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Future<void> upsert(Memory memory) async {
    final index = _memories.indexWhere((m) => m.id == memory.id);
    if (index >= 0) {
      _memories[index] = memory;
    } else {
      _memories.insert(0, memory);
    }
  }

  @override
  Future<void> delete(String id) async {
    _memories.removeWhere((m) => m.id == id);
  }

  @override
  Future<List<Memory>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAll();

    final scored = <({Memory memory, int score})>[];
    for (final m in _memories) {
      final hay = '${m.transcript} ${m.title} ${m.location}'.toLowerCase();
      if (!hay.contains(q) && !_fuzzyContains(hay, q)) continue;
      final score = hay.contains(q) ? 2 : 1;
      scored.add((memory: m, score: score));
    }
    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return b.memory.updatedAt.compareTo(a.memory.updatedAt);
    });
    return scored.map((e) => e.memory).toList(growable: false);
  }

  @override
  Future<void> replaceAll(List<Memory> memories) async {
    _memories
      ..clear()
      ..addAll(memories);
  }

  @override
  Future<void> clear() async => _memories.clear();

  @override
  Future<void> close() async {}

  bool _fuzzyContains(String haystack, String needle) {
    if (needle.length < 3) return false;
    for (var i = 0; i < needle.length - 1; i++) {
      final partial = needle.substring(0, i) + needle.substring(i + 1);
      if (haystack.contains(partial)) return true;
    }
    return false;
  }
}

/// Seed data matching the approved mobile.html prototype (UI review only).
List<Memory> createSeedMemories({DateTime? now}) {
  final current = now ?? DateTime.now();
  return [
    Memory(
      id: 'seed-1',
      transcript: 'Passport, in the second drawer of my work desk.',
      displayTitle: 'Passport',
      displayLocation: 'Second drawer of the work desk',
      createdAt: DateTime(current.year, current.month, current.day, 8, 42),
      updatedAt: DateTime(current.year, current.month, current.day, 8, 42),
      imagePath: null,
    ),
    Memory(
      id: 'seed-2',
      transcript: 'MacBook charger, on the top shelf of the bedroom closet.',
      displayTitle: 'MacBook charger',
      displayLocation: 'Top shelf, bedroom closet',
      createdAt: DateTime(current.year, current.month, current.day)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 21, minutes: 18)),
      updatedAt: DateTime(current.year, current.month, current.day)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 21, minutes: 18)),
      imagePath: null,
    ),
    Memory(
      id: 'seed-3',
      transcript: 'Sony camera cable, in moving box 17.',
      displayTitle: 'Sony camera cable',
      displayLocation: 'Moving box 17',
      createdAt: DateTime(current.year, 8, 2, 16, 20),
      updatedAt: DateTime(current.year, 8, 2, 16, 20),
      imagePath: null,
    ),
  ];
}
