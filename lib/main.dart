import 'package:flutter/material.dart';
import 'package:my_tasks/screens/login_screen.dart';
import 'package:my_tasks/screens/splash_screen.dart';
import 'package:my_tasks/screens/task_list_screen.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyTasksApp());
}

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Tasks',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        // We'll let Splash handle navigation after checking auth state.
        home: const SplashScreen(),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          TaskListScreen.routeName: (_) => const TaskListScreen(),
        },
      ),
    );
  }
}
