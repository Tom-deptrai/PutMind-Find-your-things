import 'package:flutter/material.dart';

import '../theme/app_typography.dart';
import '../l10n/app_localizations.dart';

class EmptyMemoriesView extends StatelessWidget {
  const EmptyMemoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.homeEmptyTitle,
              style: AppTypography.emptyTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 7),
            Text(
              l10n.homeEmptyBody,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
