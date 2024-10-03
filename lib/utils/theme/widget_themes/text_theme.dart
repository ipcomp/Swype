import 'package:flutter/material.dart';
import 'package:swype/utils/constants/colors.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme textTheme = TextTheme(
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: CColors.primary,
      height: 1.5,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: CColors.secondary,
      height: 1.5,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: CColors.secondary,
      height: 1.5,
    ),
  );
}
