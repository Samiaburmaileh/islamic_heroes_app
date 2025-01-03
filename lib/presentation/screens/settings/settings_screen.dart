import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final language = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Theme Section
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(_getThemeText(context, themeMode)),
            leading: const Icon(Icons.palette_outlined),
            onTap: () => _showThemeDialog(context, ref),
          ),
          const Divider(),

          // Language Section
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(language),
            leading: const Icon(Icons.language),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),

          // Font Size Section
          ListTile(
            title: Text(l10n.fontSize),
            subtitle: Slider(
              value: fontSize,
              min: 0.8,
              max: 1.4,
              divisions: 3,
              label: _getFontSizeLabel(context, fontSize),
              onChanged: (value) {
                ref.read(fontSizeProvider.notifier).setFontSize(value);
              },
            ),
            leading: const Icon(Icons.text_fields),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _getThemeText(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getFontSizeLabel(BuildContext context, double scale) {
    if (scale <= 0.8) return 'Small';
    if (scale <= 1.0) return 'Normal';
    if (scale <= 1.2) return 'Large';
    return 'Extra Large';
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    final currentTheme = ref.read(themeModeProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeText(context, mode)),
              value: mode,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final languages = ['English', 'Arabic'];
    final currentLanguage = ref.read(languageProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}