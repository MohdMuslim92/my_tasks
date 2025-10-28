import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_tasks/providers/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  final double iconSize;
  const ThemeToggle({super.key, this.iconSize = 22});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final isDark = themeProv.isDark;

    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: iconSize),
      onPressed: () => themeProv.toggleTheme(),
    );
  }
}
