import 'dart:convert';

/// Maximum photos allowed on a single Memory (Product Spec).
const int kMaxPhotosPerMemory = 5;

/// A saved Memory — one or more photos + shared transcript.
class Memory {
  const Memory({
    required this.id,
    required this.transcript,
    required this.createdAt,
    required this.updatedAt,
    this.imagePaths = const [],
    this.displayTitle,
    this.displayLocation,
  });

  final String id;

  /// Full transcript is the primary data source (Product Spec §18).
  final String transcript;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Ordered local image paths. Index 0 is the cover photo.
  final List<String> imagePaths;

  /// Optional display helpers (not persisted as primary fields).
  final String? displayTitle;
  final String? displayLocation;

  /// Cover photo path (index 0), or null when empty.
  String? get imagePath => imagePaths.isEmpty ? null : imagePaths.first;

  int get photoCount => imagePaths.length;

  bool get hasMultiplePhotos => imagePaths.length > 1;

  String get title {
    if (displayTitle != null && displayTitle!.trim().isNotEmpty) {
      return displayTitle!;
    }
    return _inferTitle(transcript);
  }

  String get location {
    if (displayLocation != null && displayLocation!.trim().isNotEmpty) {
      return displayLocation!;
    }
    return _inferLocation(transcript);
  }

  Memory copyWith({
    String? id,
    String? transcript,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imagePaths,
    String? displayTitle,
    String? displayLocation,
  }) {
    return Memory(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePaths: imagePaths ?? this.imagePaths,
      displayTitle: displayTitle ?? this.displayTitle,
      displayLocation: displayLocation ?? this.displayLocation,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'transcript': transcript,
      // Legacy single column kept in sync with cover for older readers.
      'image_path': imagePath,
      'image_paths': jsonEncode(imagePaths),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Memory.fromMap(Map<String, Object?> map) {
    return Memory(
      id: map['id']! as String,
      transcript: map['transcript']! as String,
      imagePaths: _pathsFromMap(map),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']! as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']! as int),
    );
  }

  static List<String> _pathsFromMap(Map<String, Object?> map) {
    final raw = map['image_paths'];
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .whereType<String>()
              .where((e) => e.trim().isNotEmpty)
              .toList(growable: false);
        }
      } catch (_) {
        // Fall through to legacy column.
      }
    }
    final single = map['image_path'] as String?;
    if (single == null || single.isEmpty) return const [];
    return [single];
  }

  static String _inferTitle(String transcript) {
    final trimmed = transcript.trim();
    if (trimmed.isEmpty) return 'Memory';
    final parts = trimmed.split(RegExp(r'[,.]'));
    final first = parts.first.trim();
    if (first.isEmpty) return trimmed;
    return first.length > 40 ? '${first.substring(0, 40)}…' : first;
  }

  static String _inferLocation(String transcript) {
    final trimmed = transcript.trim();
    final lower = trimmed.toLowerCase();
    for (final marker in [' in ', ' at ', ' on ', ', ']) {
      final idx = lower.indexOf(marker);
      if (idx > 0) {
        return trimmed.substring(idx + marker.length).trim();
      }
    }
    return trimmed;
  }
}
