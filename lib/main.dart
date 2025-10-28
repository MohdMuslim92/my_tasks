import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_tasks/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/providers/theme_provider.dart';
import 'package:my_tasks/screens/add_edit_task_screen.dart';
import 'package:my_tasks/screens/login_screen.dart';
import 'package:my_tasks/screens/register_screen.dart';
import 'package:my_tasks/screens/splash_screen.dart';
import 'package:my_tasks/screens/task_list_screen.dart';
import 'package:my_tasks/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyTasksApp());
}

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return AnimatedBuilder(
            animation: themeProv,
            builder: (context, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'My Tasks',
                theme: appLightTheme,
                darkTheme: appDarkTheme,
                themeMode: themeProv.mode,
                // We'll let Splash handle navigation after checking auth state.
                home: const SplashScreen(),
                routes: {
                  LoginScreen.routeName: (_) => const LoginScreen(),
                  RegisterScreen.routeName: (_) => const RegisterScreen(),
                  TaskListScreen.routeName: (_) => const TaskListScreen(),
                  AddEditTaskScreen.routeName: (_) => const AddEditTaskScreen(),
                },
              );
            },
          );
        }
      )
    );
  }
}
