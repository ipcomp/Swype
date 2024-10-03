import 'package:flutter/material.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:swype/utils/theme/widget_themes/input_decoration_theme.dart';
import 'package:swype/utils/theme/widget_themes/text_theme.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'SK-Modernist',
    primaryColor: CColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: CElevatedButtonTheme.elevatedButtonTheme,
    inputDecorationTheme: CInputDecorationTheme.inputDecorationTheme,
    textTheme: CTextTheme.textTheme,
  );
}
