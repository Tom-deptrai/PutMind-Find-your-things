import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.dark = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool dark;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: dark ? const Color(0x16FFFFFF) : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.iconButton),
        side: BorderSide(
          color: dark ? const Color(0x22FFFFFF) : AppColors.line,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.iconButton),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 20,
            color: dark ? AppColors.white : AppColors.ink,
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
