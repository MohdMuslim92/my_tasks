import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/screens/register_screen.dart';
import 'package:my_tasks/screens/task_list_screen.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:my_tasks/widgets/app_logo.dart';
import 'package:my_tasks/widgets/auth_form.dart';
import 'package:my_tasks/widgets/language_switcher.dart';
import 'package:my_tasks/widgets/theme_toggle.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // demo credentials
  static const _demoEmail = 'test@example.com';
  static const _demoPassword = 'Test@1234';

  // If non-null, AuthForm will prefill these values.
  String? _initialEmail;
  String? _initialPassword;

  /// This will be incremented to force AuthForm to re-apply
  /// initial values no matter what.
  int _prefillNonce = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context, listen: false);
    final tasks = Provider.of<TaskProvider>(context, listen: false);

    Future<void> _onSubmit({required String email, required String password}) async {
      // Attempt to login
      await auth.login(email: email, password: password);
      // bind provider to current user
      tasks.bindToUser(auth.userId);
      // navigate
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed(TaskListScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.signIn),
        actions: [
          const ThemeToggle(),
          const LanguageSwitcher(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const AppLogo(size: 90, showText: true),
                const SizedBox(height: 24),
                AuthForm(
                  isRegister: false,
                  submitLabel: loc.signIn,
                  onSubmit: _onSubmit,
                  initialEmail: _initialEmail,
                  initialPassword: _initialPassword,
                  prefillNonce: _prefillNonce,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Force clear then refill demo credentials
                        setState(() {
                          _initialEmail = _demoEmail;
                          _initialPassword = _demoPassword;
                          _prefillNonce++; // signal AuthForm to reapply values
                        });
                      },
                      child: Text(loc.useDemoCredentials),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      },
                      child: Text(loc.createAccount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
