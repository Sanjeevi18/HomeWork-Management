import 'package:flutter/material.dart';

class AppThemes {
  // Custom Color Palette
  static const Color paleCerulean = Color(0xFFA5C8E4); // soft, gentle blue
  static const Color teaGreen = Color(0xFFC0ECCC); // refreshing minty tone
  static const Color blond = Color(0xFFF9F0C1); // warm, neutral cream
  static const Color deepChampagne = Color(0xFFF4CDA6); // subtle peach warmth
  static const Color mauvelous = Color(0xFFF6A8A6); // mild, calming rose color

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: paleCerulean,
    scaffoldBackgroundColor: blond,
    colorScheme: ColorScheme.light(
      primary: paleCerulean,
      secondary: teaGreen,
      surface: Colors.white,
      background: blond,
      error: mauvelous,
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
        backgroundColor: paleCerulean,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: paleCerulean.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: paleCerulean.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: paleCerulean, width: 2),
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
      backgroundColor: teaGreen,
      foregroundColor: Colors.black87,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: paleCerulean,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    colorScheme: ColorScheme.dark(
      primary: paleCerulean,
      secondary: teaGreen,
      surface: const Color(0xFF2D2D2D),
      background: const Color(0xFF1E1E1E),
      error: mauvelous,
      onPrimary: Colors.black87,
      onSecondary: Colors.black87,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: paleCerulean,
        foregroundColor: Colors.black87,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: paleCerulean.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: paleCerulean.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: paleCerulean, width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2D2D2D),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: teaGreen,
      foregroundColor: Colors.black87,
    ),
  );
}
