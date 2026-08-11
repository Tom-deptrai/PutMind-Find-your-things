/// A saved Memory — photo + transcript of where something was put.
class Memory {
  const Memory({
    required this.id,
    required this.transcript,
    required this.createdAt,
    required this.updatedAt,
    this.imageAssetKey,
    this.displayTitle,
    this.displayLocation,
  });

  final String id;

  /// Full transcript is the primary data source (Product Spec §18).
  final String transcript;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Step 1: mock/placeholder key. Later steps will use local file paths.
  final String? imageAssetKey;

  /// Optional display helpers inferred from transcript for cards.
  final String? displayTitle;
  final String? displayLocation;

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
    String? imageAssetKey,
    String? displayTitle,
    String? displayLocation,
  }) {
    return Memory(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageAssetKey: imageAssetKey ?? this.imageAssetKey,
      displayTitle: displayTitle ?? this.displayTitle,
      displayLocation: displayLocation ?? this.displayLocation,
    );
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
