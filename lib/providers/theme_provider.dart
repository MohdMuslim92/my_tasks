import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _kThemePrefKey = 'theme_mode'; // values: 'light' or 'dark'

  ThemeMode _mode = ThemeMode.light;
  bool _initialized = false;

  ThemeProvider() {
    _loadFromPrefs();
  }

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;
  bool get initialized => _initialized;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemePrefKey);
    if (saved != null && saved == 'dark') {
      _mode = ThemeMode.dark;
    } else {
      _mode = ThemeMode.light;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_mode == ThemeMode.dark) {
      await setLight();
    } else {
      await setDark();
    }
  }

  Future<void> setDark() async {
    _mode = ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePrefKey, 'dark');
  }

  Future<void> setLight() async {
    _mode = ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePrefKey, 'light');
  }
}
