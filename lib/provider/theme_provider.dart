import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'themeMode';
  bool _initialized = false;

  @override
  ThemeMode build() {
    if (!_initialized) {
      _initialized = true;
      Future.microtask(_loadThemeMode); // ✅ SAFE
    }
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_key);
      if (value != null) {
        state = _stringToThemeMode(value);
      }
    } catch (e) {
      // Prevent crash if plugin not ready
      debugPrint('Theme load failed: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, _themeModeToString(mode));
    } catch (_) {}
  }

  Future<void> toggleTheme() async {
    await setThemeMode(
      state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

final themeModeProvider =
NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
