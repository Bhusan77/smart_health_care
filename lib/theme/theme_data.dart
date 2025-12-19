import 'package:flutter/material.dart';
import 'package:smart_health_care/theme/appbar_theme.dart';
import 'package:smart_health_care/theme/apply_scaffold_theme.dart';
import 'package:smart_health_care/theme/bottom_navigation_theme.dart';
import 'package:smart_health_care/theme/elevated_button_theme.dart';
import 'package:smart_health_care/theme/input_decoration_theme.dart';   

ThemeData getApplicationTheme() {
  const Color primaryColor = Color(0xFF5A9C41);

  ThemeData baseTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'OpenSans Regular',

    // COLOR SCHEME
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 110, 177, 223),
      brightness: Brightness.light,
    ),

    // THEMES
    appBarTheme: getAppBarTheme(),
    bottomNavigationBarTheme: getBottomNavigationTheme(),
    elevatedButtonTheme: getElevatedButtonTheme(),
    inputDecorationTheme: getInputDecorationTheme(),

    // TEXT BUTTON
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 110, 177, 223),
      ),
    ),

    // OUTLINED BUTTON
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 110, 177, 223),
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  // APPLY SCAFFOLD THEME
  return applyScaffoldTheme(baseTheme);
}