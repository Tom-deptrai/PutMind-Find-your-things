import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.1,
  );

  static const screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const captureTitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const memoryTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.5,
  );

  static const location = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.location,
    height: 1.35,
  );

  static const meta = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.meta,
  );

  static const section = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
  );

  static const groupLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
    color: AppColors.meta,
  );

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const buttonPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const unlockTitle = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const onboardingTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const emptyTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const price = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const prompt = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static const toggle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF59655E),
  );
}
