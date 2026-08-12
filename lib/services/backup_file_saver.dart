import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Writes an encrypted backup to a user-chosen location via the system picker.
abstract class BackupFileSaver {
  /// Returns the saved path/URI string, or null if the user cancelled.
  Future<String?> saveBackup({
    required String fileName,
    required Uint8List bytes,
  });
}

/// Default saver using [FilePicker.saveFile] (SAF on Android, Files on iOS).
class SystemBackupFileSaver implements BackupFileSaver {
  const SystemBackupFileSaver();

  @override
  Future<String?> saveBackup({
    required String fileName,
    required Uint8List bytes,
  }) {
    return FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: const ['backup'],
    );
  }
}

/// Default backup filename: `PutMindBackup_YYYY-MM-DD_HH-mm.backup`
String defaultBackupFileName([DateTime? now]) {
  final t = now ?? DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return 'PutMindBackup_${t.year}-${two(t.month)}-${two(t.day)}_'
      '${two(t.hour)}-${two(t.minute)}.backup';
}
