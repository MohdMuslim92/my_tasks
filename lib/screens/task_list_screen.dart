import 'package:flutter/material.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  static const routeName = '/tasks';
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              // After logout, go to login and clear stack
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome — you are logged in!\n',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
