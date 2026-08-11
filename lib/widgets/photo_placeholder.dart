import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

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

class CapturePreviewPlaceholder extends StatelessWidget {
  const CapturePreviewPlaceholder({super.key, this.captured = false});

  final bool captured;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: captured
              ? const [
                  AppColors.capturePreviewStart,
                  AppColors.capturePreviewMid,
                  AppColors.capturePreviewEnd,
                ]
              : const [Color(0xFF1A221E), Color(0xFF3A4740), Color(0xFF6B7568)],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: captured
          ? null
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Camera preview (mock)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
