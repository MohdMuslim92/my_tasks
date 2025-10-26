import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Wait a little so splash is visible
    await Future.delayed(const Duration(milliseconds: 1200));

    final auth = Provider.of<AuthService>(context, listen: false);

    // Ensure prefs are loaded if still pending in constructor
    // Give AuthService a small time to load state.
    await Future.delayed(const Duration(milliseconds: 300));

    if (auth.isLoggedIn) {
      // If logged in, push replacement to tasks.
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(TaskListScreen.routeName);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppLogo(size: 120),
      ),
    );
  }
}
