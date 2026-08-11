import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

String formatMemoryTimestamp(
  BuildContext context,
  DateTime dateTime, {
  DateTime? now,
}) {
  final loc = AppLocalizations.of(context);
  final current = (now ?? DateTime.now()).toLocal();
  final local = dateTime.toLocal();

  final today = DateTime(current.year, current.month, current.day);
  final thatDay = DateTime(local.year, local.month, local.day);

  final time = DateFormat.jm(
    Localizations.localeOf(context).toString(),
  ).format(local);

  if (thatDay == today) {
    return '${loc?.today ?? 'Today'}, $time';
  }

  if (thatDay == today.subtract(const Duration(days: 1))) {
    return '${loc?.yesterday ?? 'Yesterday'}, $time';
  }

  final datePart = DateFormat.MMMd(
    Localizations.localeOf(context).toString(),
  ).format(local);
  return '$datePart, $time';
}
