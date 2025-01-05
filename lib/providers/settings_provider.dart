import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const String _key = 'theme_mode';

  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final value = _prefs.getString(_key);
    if (value != null) {
      state = ThemeMode.values.firstWhere(
            (e) => e.toString() == value,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_key, mode.toString());
    state = mode;
  }
}

// Font Size Provider
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FontSizeNotifier(prefs);
});

class FontSizeNotifier extends StateNotifier<double> {
  final SharedPreferences _prefs;
  static const String _key = 'font_size';

  FontSizeNotifier(this._prefs) : super(1.0) {
    _loadFontSize();
  }

  void _loadFontSize() {
    state = _prefs.getDouble(_key) ?? 1.0;
  }

  Future<void> setFontSize(double size) async {
    await _prefs.setDouble(_key, size);
    state = size;
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LanguageNotifier(prefs);
});

class LanguageNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const String _key = 'language';
  static const String defaultLanguage = 'en';

  LanguageNotifier(this._prefs) : super(defaultLanguage) {
    _loadLanguage();
  }

  void _loadLanguage() {
    state = _prefs.getString(_key) ?? defaultLanguage;
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_key, languageCode);
    state = languageCode;
  }
}

// Offline Mode Provider
final offlineModeProvider = StateNotifierProvider<OfflineModeNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OfflineModeNotifier(prefs);
});

class OfflineModeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const String _key = 'offline_mode';

  OfflineModeNotifier(this._prefs) : super(false) {
    _loadOfflineMode();
  }

  void _loadOfflineMode() {
    state = _prefs.getBool(_key) ?? false;
  }

  Future<void> update(bool value) async {
    await _prefs.setBool(_key, value);
    state = value;
  }
}

// Notifications Provider
final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotificationsNotifier(prefs);
});

class NotificationsNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const String _key = 'notifications_enabled';

  NotificationsNotifier(this._prefs) : super(true) {
    _loadNotificationsSetting();
  }

  void _loadNotificationsSetting() {
    state = _prefs.getBool(_key) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    await _prefs.setBool(_key, value);
    state = value;
  }
}

// Translation Provider
final translationProvider = StateNotifierProvider<TranslationNotifier, Map<String, String>>((ref) {
  final language = ref.watch(languageProvider);
  return TranslationNotifier(language);
});

class TranslationNotifier extends StateNotifier<Map<String, String>> {
  TranslationNotifier(String language) : super(_getTranslations(language));

  static Map<String, String> _getTranslations(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return {
          'settings': 'الإعدادات',
          'theme': 'المظهر',
          'language': 'اللغة',
          'fontSize': 'حجم الخط',
          'offlineMode': 'وضع عدم الاتصال',
          'notifications': 'الإشعارات',
          'clearCache': 'مسح ذاكرة التخزين المؤقت',
          'about': 'حول',
          'version': 'الإصدار',
        };
      default:
        return {
          'settings': 'Settings',
          'theme': 'Theme',
          'language': 'Language',
          'fontSize': 'Font Size',
          'offlineMode': 'Offline Mode',
          'notifications': 'Notifications',
          'clearCache': 'Clear Cache',
          'about': 'About',
          'version': 'Version',
        };
    }
  }
}

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this provider in main.dart');
});