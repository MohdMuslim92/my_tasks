import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_tasks/providers/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  final double iconSize;
  const LanguageSwitcher({super.key, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    final localeProv = Provider.of<LocaleProvider>(context);
    // current language code (null => system; fallback to 'en')
    final current = localeProv.locale?.languageCode ?? Localizations.localeOf(context).languageCode;
    final loc = AppLocalizations.of(context);

    return PopupMenuButton<String>(
      tooltip: 'Switch language',
      icon: SizedBox(
        width: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: iconSize),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  current == 'ar' ? 'العربية' : 'EN',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      onSelected: (code) async {
        await localeProv.setLanguageCode(code);
      },
      itemBuilder: (ctx) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              const Text('EN'),
              const Spacer(),
              Text('English', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ar',
          child: Row(
            children: [
              const Text('AR'),
              const Spacer(),
              Text('العربية', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
