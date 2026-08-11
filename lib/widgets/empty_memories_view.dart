import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

class EmptyMemoriesView extends StatelessWidget {
  const EmptyMemoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your things will appear here.',
              style: AppTypography.emptyTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 7),
            Text(
              'Take a photo and tell PutMind where you stored it.',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
