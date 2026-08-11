import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Saves Memory images under the app documents directory.
///
/// Database stores the absolute path; images are never uploaded.
class ImageStorage {
  ImageStorage._(this._imagesDir);

  final Directory _imagesDir;
  static const _uuid = Uuid();

  static Future<ImageStorage> create() async {
    if (kIsWeb) {
      // Web uses mock paths only — no filesystem writes.
      return ImageStorage._(Directory.systemTemp);
    }
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'memories', 'images'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return ImageStorage._(dir);
  }

  /// Creates an [ImageStorage] rooted at [directory] (useful for tests).
  factory ImageStorage.forDirectory(Directory directory) {
    return ImageStorage._(directory);
  }

  Directory get imagesDirectory => _imagesDir;

  /// Copies [sourcePath] into durable app-local storage and returns the new path.
  Future<String> persistCapturedImage(String sourcePath, {String? id}) async {
    if (kIsWeb) {
      return sourcePath;
    }

    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('Captured image missing: $sourcePath');
    }

    final ext = p.extension(sourcePath).isEmpty
        ? '.jpg'
        : p.extension(sourcePath);
    final name = '${id ?? _uuid.v4()}$ext';
    final destPath = p.join(_imagesDir.path, name);
    final dest = await source.copy(destPath);
    return dest.path;
  }

  /// Deletes [imagePath] if it lives inside the app images directory.
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty || kIsWeb) return;
    final file = File(imagePath);
    if (!file.path.startsWith(_imagesDir.path)) {
      // Refuse deleting files outside managed storage.
      return;
    }
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Replaces an existing memory image: persist new file, then delete old.
  Future<String> replaceImage({
    required String sourcePath,
    required String? previousPath,
    String? id,
  }) async {
    final newPath = await persistCapturedImage(sourcePath, id: id);
    if (previousPath != null && previousPath != newPath) {
      await deleteImage(previousPath);
    }
    return newPath;
  }

  /// Deletes every path in [imagePaths] that lives under managed storage.
  Future<void> deleteImages(Iterable<String> imagePaths) async {
    for (final path in imagePaths) {
      await deleteImage(path);
    }
  }
}
