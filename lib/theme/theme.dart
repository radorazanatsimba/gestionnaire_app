// lib/theme/theme.dart
import 'package:flutter/material.dart';

final ThemeData meahTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00BCD4), // Bleu turquoise
    primary: const Color(0xFF00BCD4),
    secondary: const Color(0xFFF44336), // Rouge
    tertiary: const Color(0xFF4CAF50),  // Vert
    background: Colors.white,
    brightness: Brightness.light,
  ),

  // Typographie
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 16),
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00BCD4),
    elevation: 2,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Boutons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF44336),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),

  // Champs de texte
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF00BCD4)),
    ),
    labelStyle: const TextStyle(color: Color(0xFF00BCD4)),
  ),

  // Icônes
  iconTheme: const IconThemeData(
    color: Color(0xFF00BCD4),
  ),

  // Cartes
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: Colors.black.withOpacity(0.1),
  ),
);
