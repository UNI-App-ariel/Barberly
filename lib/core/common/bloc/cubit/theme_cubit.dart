import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'themeMode';

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  // Toggle theme based on the current state, cycling through light, dark, and system
  void toggleTheme() async {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
      await _saveTheme('light');
    } else if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      await _saveTheme('dark');
    }
  }

  // Save theme mode in SharedPreferences
  Future<void> _saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
  }

  // Load theme mode from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString(_themeKey) ?? 'system'; // Default to system theme

    switch (themeMode) {
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'light':
        emit(ThemeMode.light);
        break;
      default:
        emit(ThemeMode.system);
        break;
    }
  }

  // Set a specific theme mode manually
  void setTheme(ThemeMode mode) async {
    emit(mode);
    switch (mode) {
      case ThemeMode.dark:
        await _saveTheme('dark');
        break;
      case ThemeMode.light:
        await _saveTheme('light');
        break;
      case ThemeMode.system:
        await _saveTheme('system');
        break;
    }
  }

  // Get the current theme mode
  ThemeMode getTheme() {
    return state;
  }

  bool isSystemTheme() {
    return state == ThemeMode.system;
  }
}