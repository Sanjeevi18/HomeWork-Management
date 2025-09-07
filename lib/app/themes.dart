import 'package:flutter/material.dart';

class AppThemes {
  // Your Custom Color Palette
  static const Color color1 = Color(0xFFA5C8E4); // Pale blue
  static const Color color2 = Color(0xFFC0ECCC); // Tea green
  static const Color color3 = Color(0xFFF9F0C1); // Blond/cream
  static const Color color4 = Color(0xFFF4CDA6); // Deep champagne
  static const Color color5 = Color(0xFFF6A8A6); // Mauvelous/rose

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: color1,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: color1,
      secondary: color2,
      surface: Colors.white,
      background: Colors.white,
      error: color5,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color1,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color1.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color1.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: color1, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color2,
      foregroundColor: Colors.black87,
    ),
  );
}
