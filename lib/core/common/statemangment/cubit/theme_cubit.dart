import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Cubit that manages the application's theme mode (light, dark, or system).
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'themeMode';

  /// Initializes the ThemeCubit and loads the saved theme mode from SharedPreferences.
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Toggles the theme based on the current state, cycling through light and dark modes.
  ///
  /// If the current theme is dark, it switches to light. If it is light, it switches to dark.
  /// The theme mode is then saved in SharedPreferences.
  void toggleTheme() async {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
      await _saveTheme('light');
    } else if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      await _saveTheme('dark');
    }
  }

  /// Saves the specified theme mode in SharedPreferences.
  ///
  /// [themeMode] must be either 'light', 'dark', or 'system'.
  Future<void> _saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
  }

  /// Loads the theme mode from SharedPreferences and emits the corresponding state.
  ///
  /// If no saved theme mode is found, it defaults to 'system'.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode =
        prefs.getString(_themeKey) ?? 'system'; // Default to system theme

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

  /// Sets a specific theme mode manually and saves it in SharedPreferences.
  ///
  /// [mode] must be either ThemeMode.dark, ThemeMode.light, or ThemeMode.system.
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

  /// Returns the current theme mode.
  ThemeMode getTheme() {
    return state;
  }

  /// Checks if the current theme mode is set to system.
  ///
  /// Returns true if the theme is set to system, otherwise false.
  bool isSystemTheme() {
    return state == ThemeMode.system;
  }
}
