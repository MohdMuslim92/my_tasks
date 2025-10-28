import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/screens/login_screen.dart';
import 'package:my_tasks/screens/task_list_screen.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:my_tasks/widgets/app_logo.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _minSplashDuration = Duration(seconds: 3);
  StreamSubscription<User?>? _authSub;
  bool _navigated = false;
  DateTime? _startedAt;
  User? _latestUser;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _setupBindingsAndNavigate();
  }

  Future<void> _setupBindingsAndNavigate() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final tasks = Provider.of<TaskProvider>(context, listen: false);

    // Listen to auth state changes and bind/unbind TaskProvider accordingly.
    // We'll record the first auth event and then navigate after the minimum duration.
    _authSub = auth.authStateChanges().listen((user) async {
      // store latest user (we will navigate using this)
      _latestUser = user;

      if (user != null) {
        tasks.bindToUser(user.uid);
      } else {
        tasks.bindToUser(null);
      }

      // Decide whether we should navigate now or wait until min duration elapses.
      await _navigateWhenReady();
    });

    // Also: if AuthService is still initializing (auth.isLoading), wait a bit
    // but don't block the min-duration guarantee below. This loop ensures we
    // don't navigate before AuthService finished initial checks.
    int attempts = 0;
    while (auth.isLoading && attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 150));
      attempts++;
    }

    // If no auth event arrived yet (rare), try navigate now (this will still
    // respect the minimum splash duration)
    if (_latestUser == null && !_navigated) {
      await _navigateWhenReady();
    }
  }

  Future<void> _navigateWhenReady() async {
    if (_navigated) return; // avoid double navigation

    final started = _startedAt ?? DateTime.now();
    final elapsed = DateTime.now().difference(started);
    final remaining = _minSplashDuration - elapsed;
    if (remaining > Duration.zero) {
      // Wait so the splash is visible for at least the min duration
      await Future.delayed(remaining);
    }

    if (_navigated) return;
    _navigated = true;

    if (!mounted) return;

    if (_latestUser != null) {
      Navigator.of(context).pushReplacementNamed(TaskListScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(size: 120),
      ),
    );
  }
}
