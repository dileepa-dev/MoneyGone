import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF0DB14B);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
    ),

    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: false,

      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),

      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),

      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryGreen,
          width: 1.5,
        ),
      ),

      hintStyle: const TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
      ),

      labelStyle: const TextStyle(
        color: Color(0xFF999999),
        fontSize: 12,
      ),
    ),
  );
}