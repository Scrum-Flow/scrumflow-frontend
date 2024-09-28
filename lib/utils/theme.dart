import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.grey;
  static const Color secondaryColor = Colors.black;
  static const Color errorColor = Colors.red;
  static const Color backgroundColor = Colors.white;
  static const Color successColor = Colors.green;
  static const Color onSuccess = Colors.white;
  static const Color ligthBlueScrum = Color(0xFF28a8f7);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      colorScheme: const ColorScheme(
        surface: backgroundColor,
        onSurface: Colors.black,
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
    );
  }
}
