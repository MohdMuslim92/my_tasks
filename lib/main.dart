import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:my_tasks/providers/locale_provider.dart';
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
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProv, localeProv, _) {
          // Ensure we don't build before localeProv is initialized (optional guard)
          if (!localeProv.initialized) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Tasks',
            theme: appLightTheme,
            darkTheme: appDarkTheme,
            themeMode: themeProv.mode,

            // locale binding
            locale: localeProv.locale, // null → system locale
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Routes
            home: const SplashScreen(),
            routes: {
              LoginScreen.routeName: (_) => const LoginScreen(),
              RegisterScreen.routeName: (_) => const RegisterScreen(),
              TaskListScreen.routeName: (_) => const TaskListScreen(),
              AddEditTaskScreen.routeName: (_) => const AddEditTaskScreen(),
            },
          );
        },
      ),
    );
  }
}
