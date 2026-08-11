import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/memory_time_format.dart';
import 'photo_placeholder.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({super.key, required this.memory, required this.onTap});

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final variant = memory.id.hashCode.abs();

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.memory),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.memory),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 82,
                height: 82,
                child: MemoryPhoto(
                  imagePath: memory.imagePath,
                  variant: variant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      memory.transcript,
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatMemoryTimestamp(context, memory.updatedAt),
                            style: AppTypography.meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (memory.hasMultiplePhotos) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.photo_library_outlined,
                            size: 14,
                            color: AppColors.meta,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${memory.photoCount}',
                            style: AppTypography.meta,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
