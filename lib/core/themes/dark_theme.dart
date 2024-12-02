import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blue,
  // scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
  scaffoldBackgroundColor: Colors.black, // Dark background
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF1E1E1E),
    primary: Colors.blue,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade900, // Darker secondary color
    tertiary: Colors.grey.shade600, // Slightly lighter tertiary color
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // Matches the dark surface color
    elevation: 0,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
