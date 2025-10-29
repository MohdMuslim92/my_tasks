import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/screens/task_list_screen.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:my_tasks/widgets/app_logo.dart';
import 'package:my_tasks/widgets/auth_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context, listen: false);
    final tasks = Provider.of<TaskProvider>(context, listen: false);

    Future<void> _onSubmit({required String email, required String password}) async {
      // This will create user in Firebase Auth
      await auth.register(email: email, password: password);
      tasks.bindToUser(auth.userId);
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed(TaskListScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.createAccount)),
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
                  isRegister: true,
                  submitLabel: loc.createAccount,
                  onSubmit: _onSubmit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(loc.alreadyHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
