import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages app locale (language). Stores languageCode in SharedPreferences.
/// Keys: 'app_locale' -> languageCode (e.g., 'en', 'ar').
/// If locale == null -> use system locale (fallback handled by MaterialApp).
class LocaleProvider extends ChangeNotifier {
  static const _prefKey = 'app_locale';

  Locale? _locale;
  bool _initialized = false;

  LocaleProvider() {
    _loadFromPrefs();
  }

  Locale? get locale => _locale;
  bool get initialized => _initialized;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    } else {
      _locale = null; // use system
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale? newLocale) async {
    // Accept null to revert to system locale
    if (newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (newLocale == null) {
      await prefs.remove(_prefKey);
    } else {
      await prefs.setString(_prefKey, newLocale.languageCode);
    }
  }

  Future<void> setLanguageCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }

  /// Convenience toggler between en <-> ar
  Future<void> toggleEnAr() async {
    if (_locale?.languageCode == 'ar') {
      await setLanguageCode('en');
    } else {
      await setLanguageCode('ar');
    }
  }
}
