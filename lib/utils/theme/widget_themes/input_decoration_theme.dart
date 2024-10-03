import 'package:flutter/material.dart';
import 'package:swype/utils/constants/colors.dart';

class CInputDecorationTheme {
  CInputDecorationTheme._();

  static final inputDecorationTheme = InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 20.0,
    ),
    labelStyle: TextStyle(
      color: CColors.borderColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: TextStyle(fontSize: 18, color: CColors.borderColor),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintStyle: TextStyle(color: CColors.borderColor),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE8E6EA), width: 1.0)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: CColors.primary,
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color(0xFFE8E6EA),
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
  );
}
