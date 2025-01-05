import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/utils/translation_helper.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/cache_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              ListTile(
                title: Text(tr(context, ref, 'theme')),
                subtitle: Text(_getThemeText(themeMode)),
                leading: const Icon(Icons.palette_outlined),
                onTap: () => _showThemeDialog(context),
              ),
              ListTile(
                title: const Text('Language'),
                subtitle: Text(_getLanguageText(language)),
                leading: const Icon(Icons.language),
                onTap: () => _showLanguageDialog(context),
              ),
              ListTile(
                title: const Text('Font Size'),
                subtitle: Text(_getFontSizeText(fontSize)),
                leading: const Icon(Icons.text_fields),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: fontSize,
                    min: 0.8,
                    max: 1.4,
                    divisions: 3,
                    label: _getFontSizeText(fontSize),
                    onChanged: (value) {
                      ref.read(fontSizeProvider.notifier).setFontSize(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Content',
            children: [
              SwitchListTile(
                title: const Text('Offline Mode'),
                subtitle: const Text('Download content for offline access'),
                value: ref.watch(offlineModeProvider),
                onChanged: (value) {
                  ref.read(offlineModeProvider.notifier).update(value);
                },
              ),
              ListTile(
                title: const Text('Clear Cache'),
                subtitle: const Text('Free up storage space'),
                leading: const Icon(Icons.delete_outline),
                onTap: () => _showClearCacheDialog(context),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Notifications',
            children: [
              SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: const Text('Get daily notifications about new heroes'),
                value: ref.watch(notificationsEnabledProvider),
                onChanged: (value) {
                  ref.read(notificationsEnabledProvider.notifier).setEnabled(value);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              ListTile(
                title: const Text('Version'),
                subtitle: Text(_packageInfo?.version ?? 'Loading...'),
                leading: const Icon(Icons.info_outline),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description_outlined),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip_outlined),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getLanguageText(String language) {
    switch (language) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  String _getFontSizeText(double scale) {
    if (scale <= 0.8) return 'Small';
    if (scale <= 1.0) return 'Normal';
    if (scale <= 1.2) return 'Large';
    return 'Extra Large';
  }

  Future<void> _showThemeDialog(BuildContext context) async {
    final currentTheme = ref.read(themeModeProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeText(mode)),
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

  Future<void> _showLanguageDialog(BuildContext context) async {
    final currentLanguage = ref.read(languageProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'ar',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearCacheDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await CacheService().clearCache();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared')),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}