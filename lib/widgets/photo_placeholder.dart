import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Renders a memory photo from local disk, or a prototype placeholder.
class MemoryPhoto extends StatelessWidget {
  const MemoryPhoto({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.borderRadius,
    this.variant = 0,
    this.fit = BoxFit.cover,
  });

  final String? imagePath;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final int variant;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.thumb);
    final file = _resolveFile(imagePath);

    if (file != null) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.file(
          file,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) => MemoryPhotoPlaceholder(
            height: height,
            borderRadius: radius,
            variant: variant,
          ),
        ),
      );
    }

    return MemoryPhotoPlaceholder(
      height: height,
      borderRadius: radius,
      variant: variant,
    );
  }

  File? _resolveFile(String? path) {
    if (path == null || path.isEmpty || kIsWeb) return null;
    if (path.startsWith('mock-')) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    return file;
  }
}

/// Placeholder photo matching the approved prototype gradients.
class MemoryPhotoPlaceholder extends StatelessWidget {
  const MemoryPhotoPlaceholder({
    super.key,
    this.height,
    this.borderRadius,
    this.variant = 0,
  });

  final double? height;
  final BorderRadius? borderRadius;
  final int variant;

  @override
  Widget build(BuildContext context) {
    final colors = switch (variant % 3) {
      1 => const [Color(0xFFC9D2C4), Color(0xFF6F7F6A)],
      2 => const [Color(0xFFE2D4B8), Color(0xFF7A6A55)],
      _ => const [AppColors.thumbStart, AppColors.thumbEnd],
    };

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.thumb),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}
