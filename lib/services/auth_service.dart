import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const _kLoggedInKey = 'logged_in';
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_kLoggedInKey) ?? false;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    // Simple validation: email format + non-empty password.
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email) || password.isEmpty) {
      return false;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Fake auth.
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, false);
    notifyListeners();
  }
}
