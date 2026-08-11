import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;

import '../models/memory.dart';
import 'image_storage.dart';
import 'memory_repository.dart';

/// Current PutMind encrypted backup format version.
const int kBackupFormatVersion = 1;

/// Schema version of the memories payload inside a backup.
const int kBackupSchemaVersion = 1;

const String kBackupMagic = 'PMBK';
const int kBackupPbkdf2Iterations = 210000;
const int kBackupSaltLength = 16;
const int kBackupNonceLength = 12;

/// Known silence-placeholder WAV size from Step 3 DEV assets.
const int kVoiceSilencePlaceholderBytes = 12844;

enum BackupFailureReason {
  wrongPassword,
  corrupted,
  unsupportedVersion,
  missingData,
  cancelled,
  ioError,
}

class BackupException implements Exception {
  BackupException(this.reason, [this.message]);

  final BackupFailureReason reason;
  final String? message;

  @override
  String toString() =>
      'BackupException($reason${message == null ? '' : ': $message'})';
}

class BackupManifest {
  const BackupManifest({
    required this.formatVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.memoryCount,
    required this.appVersion,
  });

  final int formatVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final int memoryCount;
  final String appVersion;

  Map<String, Object?> toJson() => {
    'formatVersion': formatVersion,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'memoryCount': memoryCount,
    'appVersion': appVersion,
  };

  factory BackupManifest.fromJson(Map<String, Object?> json) {
    return BackupManifest(
      formatVersion: json['formatVersion']! as int,
      schemaVersion: json['schemaVersion']! as int,
      createdAt: DateTime.parse(json['createdAt']! as String),
      memoryCount: json['memoryCount']! as int,
      appVersion: json['appVersion']! as String,
    );
  }
}

class DecryptedBackup {
  const DecryptedBackup({
    required this.manifest,
    required this.memories,
    required this.imageBytesByName,
  });

  final BackupManifest manifest;
  final List<Memory> memories;
  final Map<String, Uint8List> imageBytesByName;
}

/// Encrypted, versioned PutMind backup (AES-256-GCM + PBKDF2-HMAC-SHA256).
class BackupService {
  BackupService({
    required MemoryRepository repository,
    required ImageStorage imageStorage,
    String appVersion = '1.0.0',
    Random? random,
  }) : _repository = repository,
       _imageStorage = imageStorage,
       _appVersion = appVersion,
       _random = random ?? Random.secure();

  final MemoryRepository _repository;
  final ImageStorage _imageStorage;
  final String _appVersion;
  final Random _random;

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: kBackupPbkdf2Iterations,
    bits: 256,
  );
  final _aesGcm = AesGcm.with256bits();

  /// Builds an encrypted backup file bytes for [password].
  Future<Uint8List> createBackupBytes(String password) async {
    if (password.isEmpty) {
      throw BackupException(BackupFailureReason.missingData, 'Empty password');
    }
    final memories = await _repository.getAll();
    final archive = Archive();
    final exportMemories = <Map<String, Object?>>[];
    final imageNames = <String, String>{};

    for (final memory in memories) {
      String? relativeImage;
      final imagePath = memory.imagePath;
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          final ext = p.extension(imagePath).isEmpty
              ? '.jpg'
              : p.extension(imagePath);
          final name = '${memory.id}$ext';
          relativeImage = name;
          imageNames[memory.id] = name;
          archive.addFile(
            ArchiveFile(
              'images/$name',
              await file.length(),
              await file.readAsBytes(),
            ),
          );
        }
      }
      exportMemories.add({
        'id': memory.id,
        'transcript': memory.transcript,
        'createdAt': memory.createdAt.toUtc().toIso8601String(),
        'updatedAt': memory.updatedAt.toUtc().toIso8601String(),
        'image': relativeImage,
        if (memory.displayTitle != null) 'displayTitle': memory.displayTitle,
        if (memory.displayLocation != null)
          'displayLocation': memory.displayLocation,
      });
    }

    final manifest = BackupManifest(
      formatVersion: kBackupFormatVersion,
      schemaVersion: kBackupSchemaVersion,
      createdAt: DateTime.now().toUtc(),
      memoryCount: memories.length,
      appVersion: _appVersion,
    );

    final manifestBytes = utf8.encode(jsonEncode(manifest.toJson()));
    final memoriesBytes = utf8.encode(jsonEncode({'memories': exportMemories}));
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );
    archive.addFile(
      ArchiveFile('memories.json', memoriesBytes.length, memoriesBytes),
    );

    final zipBytes = Uint8List.fromList(ZipEncoder().encode(archive));
    return _encryptPayload(zipBytes, password);
  }

  /// Writes encrypted backup to [destinationPath].
  Future<File> writeBackupFile({
    required String password,
    required String destinationPath,
  }) async {
    final bytes = await createBackupBytes(password);
    final file = File(destinationPath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Decrypts and validates [bytes] without touching live data.
  Future<DecryptedBackup> decryptAndValidate(
    Uint8List bytes,
    String password,
  ) async {
    final zipBytes = await _decryptPayload(bytes, password);
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      throw BackupException(BackupFailureReason.corrupted, 'Invalid archive');
    }

    final manifestFile = archive.findFile('manifest.json');
    final memoriesFile = archive.findFile('memories.json');
    if (manifestFile == null || memoriesFile == null) {
      throw BackupException(
        BackupFailureReason.missingData,
        'Missing manifest/memories',
      );
    }

    final manifestJson =
        jsonDecode(utf8.decode(manifestFile.content as List<int>))
            as Map<String, dynamic>;
    final manifest = BackupManifest.fromJson(
      Map<String, Object?>.from(manifestJson),
    );
    if (manifest.formatVersion > kBackupFormatVersion) {
      throw BackupException(
        BackupFailureReason.unsupportedVersion,
        'format ${manifest.formatVersion}',
      );
    }
    if (manifest.schemaVersion > kBackupSchemaVersion) {
      throw BackupException(
        BackupFailureReason.unsupportedVersion,
        'schema ${manifest.schemaVersion}',
      );
    }

    final memoriesJson =
        jsonDecode(utf8.decode(memoriesFile.content as List<int>))
            as Map<String, dynamic>;
    final list = (memoriesJson['memories'] as List<dynamic>? ?? const []);
    final imageBytesByName = <String, Uint8List>{};
    for (final file in archive.files) {
      if (file.isFile && file.name.startsWith('images/')) {
        final name = file.name.substring('images/'.length);
        imageBytesByName[name] = Uint8List.fromList(file.content as List<int>);
      }
    }

    final memories = <Memory>[];
    for (final raw in list) {
      final map = Map<String, Object?>.from(raw as Map);
      final imageName = map['image'] as String?;
      memories.add(
        Memory(
          id: map['id']! as String,
          transcript: map['transcript']! as String,
          createdAt: DateTime.parse(map['createdAt']! as String),
          updatedAt: DateTime.parse(map['updatedAt']! as String),
          imagePath: imageName,
          displayTitle: map['displayTitle'] as String?,
          displayLocation: map['displayLocation'] as String?,
        ),
      );
    }

    if (memories.length != manifest.memoryCount) {
      throw BackupException(
        BackupFailureReason.corrupted,
        'Memory count mismatch',
      );
    }

    return DecryptedBackup(
      manifest: manifest,
      memories: memories,
      imageBytesByName: imageBytesByName,
    );
  }

  /// Restores [decrypted] into the live repository only after staging succeeds.
  ///
  /// Existing data is left untouched if staging fails.
  Future<void> commitRestore(DecryptedBackup decrypted) async {
    final stageDir = Directory(
      p.join(
        Directory.systemTemp.path,
        'putmind_restore_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
    await stageDir.create(recursive: true);
    try {
      final stagedImages = <String, String>{};
      for (final entry in decrypted.imageBytesByName.entries) {
        final staged = File(p.join(stageDir.path, entry.key));
        await staged.writeAsBytes(entry.value, flush: true);
        stagedImages[entry.key] = staged.path;
      }

      final restored = <Memory>[];
      for (final memory in decrypted.memories) {
        final imageName = memory.imagePath;
        String? finalPath;
        if (imageName != null && stagedImages.containsKey(imageName)) {
          finalPath = await _imageStorage.persistCapturedImage(
            stagedImages[imageName]!,
            id: p.basenameWithoutExtension(imageName),
          );
        }
        restored.add(
          memory.copyWith(
            imagePath: finalPath,
            clearImagePath: finalPath == null,
          ),
        );
      }

      // Snapshot current state for rollback if replaceAll throws.
      final previous = await _repository.getAll();
      try {
        await _repository.replaceAll(restored);
      } catch (e) {
        try {
          await _repository.replaceAll(previous);
        } catch (_) {}
        throw BackupException(BackupFailureReason.ioError, e.toString());
      }
    } finally {
      try {
        if (await stageDir.exists()) {
          await stageDir.delete(recursive: true);
        }
      } catch (_) {}
    }
  }

  Future<DecryptedBackup> restoreFromFile({
    required String filePath,
    required String password,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw BackupException(BackupFailureReason.missingData, 'File not found');
    }
    final bytes = await file.readAsBytes();
    final decrypted = await decryptAndValidate(
      Uint8List.fromList(bytes),
      password,
    );
    await commitRestore(decrypted);
    return decrypted;
  }

  Future<Uint8List> _encryptPayload(
    Uint8List plaintext,
    String password,
  ) async {
    final salt = _randomBytes(kBackupSaltLength);
    final secretKey = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final nonce = _randomBytes(kBackupNonceLength);
    final box = await _aesGcm.encrypt(
      plaintext,
      secretKey: secretKey,
      nonce: nonce,
    );

    final builder = BytesBuilder(copy: false);
    builder.add(utf8.encode(kBackupMagic));
    builder.add(_u32be(kBackupFormatVersion));
    builder.add(_u32be(kBackupPbkdf2Iterations));
    builder.add(_u16be(salt.length));
    builder.add(salt);
    builder.add(_u16be(nonce.length));
    builder.add(nonce);
    final cipher = Uint8List.fromList([...box.cipherText, ...box.mac.bytes]);
    builder.add(_u32be(cipher.length));
    builder.add(cipher);
    return builder.toBytes();
  }

  Future<Uint8List> _decryptPayload(Uint8List bytes, String password) async {
    try {
      var offset = 0;
      if (bytes.length < 8) {
        throw BackupException(BackupFailureReason.corrupted, 'Too short');
      }
      final magic = utf8.decode(bytes.sublist(0, 4));
      if (magic != kBackupMagic) {
        throw BackupException(BackupFailureReason.corrupted, 'Bad magic');
      }
      offset = 4;
      final formatVersion = _readU32be(bytes, offset);
      offset += 4;
      if (formatVersion > kBackupFormatVersion) {
        throw BackupException(
          BackupFailureReason.unsupportedVersion,
          'format $formatVersion',
        );
      }
      if (bytes.length < 16) {
        throw BackupException(BackupFailureReason.corrupted, 'Too short');
      }
      final iterations = _readU32be(bytes, offset);
      offset += 4;
      final saltLen = _readU16be(bytes, offset);
      offset += 2;
      final salt = bytes.sublist(offset, offset + saltLen);
      offset += saltLen;
      final nonceLen = _readU16be(bytes, offset);
      offset += 2;
      final nonce = bytes.sublist(offset, offset + nonceLen);
      offset += nonceLen;
      final cipherLen = _readU32be(bytes, offset);
      offset += 4;
      if (offset + cipherLen > bytes.length) {
        throw BackupException(
          BackupFailureReason.corrupted,
          'Truncated ciphertext',
        );
      }
      final cipher = bytes.sublist(offset, offset + cipherLen);
      if (cipher.length < 16) {
        throw BackupException(
          BackupFailureReason.corrupted,
          'Cipher too short',
        );
      }
      final macBytes = cipher.sublist(cipher.length - 16);
      final cipherText = cipher.sublist(0, cipher.length - 16);

      final kdf = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: 256,
      );
      final secretKey = await kdf.deriveKey(
        secretKey: SecretKey(utf8.encode(password)),
        nonce: salt,
      );

      try {
        final clear = await _aesGcm.decrypt(
          SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
          secretKey: secretKey,
        );
        return Uint8List.fromList(clear);
      } catch (_) {
        throw BackupException(BackupFailureReason.wrongPassword);
      }
    } on BackupException {
      rethrow;
    } catch (_) {
      throw BackupException(BackupFailureReason.corrupted);
    }
  }

  Uint8List _randomBytes(int length) {
    final out = Uint8List(length);
    for (var i = 0; i < length; i++) {
      out[i] = _random.nextInt(256);
    }
    return out;
  }

  static Uint8List _u16be(int value) =>
      Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.big);

  static Uint8List _u32be(int value) =>
      Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.big);

  static int _readU16be(Uint8List bytes, int offset) =>
      ByteData.sublistView(bytes).getUint16(offset, Endian.big);

  static int _readU32be(Uint8List bytes, int offset) =>
      ByteData.sublistView(bytes).getUint32(offset, Endian.big);
}
