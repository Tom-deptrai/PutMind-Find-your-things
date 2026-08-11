import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// On wide web viewports, keep PutMind in a phone-sized frame so the
/// mobile UI baseline is reviewable without becoming a desktop layout.
///
/// On narrow viewports (and all non-web platforms) the child fills the screen.
class MobileViewportFrame extends StatelessWidget {
  const MobileViewportFrame({super.key, required this.child});

  /// Matches the approved mobile.html prototype max width.
  static const double phoneWidth = 430;
  static const double phoneMinHeight = 620;
  static const double phoneMaxHeight = 900;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wideEnough = constraints.maxWidth > phoneWidth + 48;
        if (!wideEnough) return child;

        final availableHeight = constraints.maxHeight;
        final frameHeight = availableHeight.isFinite
            ? availableHeight.clamp(phoneMinHeight, phoneMaxHeight)
            : phoneMaxHeight;

        return ColoredBox(
          color: const Color(0xFFEEF1EF),
          child: Center(
            child: Container(
              width: phoneWidth,
              height: frameHeight,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.line),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2218211D),
                    blurRadius: 32,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: Size(phoneWidth, frameHeight),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  // Keep keyboard insets relative to the framed app.
                  viewInsets: MediaQuery.viewInsetsOf(context),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
