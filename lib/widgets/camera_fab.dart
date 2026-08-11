import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class CameraFab extends StatelessWidget {
  const CameraFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(AppRadius.fab),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.fab),
        child: const SizedBox(
          width: 72,
          height: 72,
          child: Icon(
            Icons.camera_alt_rounded,
            color: AppColors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
