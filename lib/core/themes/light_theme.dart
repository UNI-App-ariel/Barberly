import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: const Color(0xFFf4f4f4),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade400,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFf4f4f4),
    elevation: 0,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
);
