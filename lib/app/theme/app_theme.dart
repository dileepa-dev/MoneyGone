import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF0DB14B);

  // Light theme properties
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0DB14B),
      brightness: Brightness.light,
    ),

    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: false,

      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),

      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF0DB14B),
          width: 1.5,
        ),
      ),

      hintStyle: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
      ),

      labelStyle: TextStyle(
        color: Color(0xFF999999),
        fontSize: 12,
      ),
    ),
  );

  // Dark theme properties

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF121212),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0DB14B),
      brightness: Brightness.dark,
    ),

    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: false,

      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF444444),
        ),
      ),

      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF444444),
        ),
      ),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF0DB14B),
          width: 1.5,
        ),
      ),

      hintStyle: TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 14,
      ),

      labelStyle: TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 12,
      ),
    ),

    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
    ),
  );
}