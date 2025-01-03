import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsService(prefs);
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return ThemeModeNotifier(settings);
});

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return FontSizeNotifier(settings);
});

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return LanguageNotifier(settings);
});

final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return NotificationsNotifier(settings);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SettingsService _settings;

  ThemeModeNotifier(this._settings) : super(_settings.getThemeMode());

  Future<void> setThemeMode(ThemeMode mode) async {
    await _settings.setThemeMode(mode);
    state = mode;
  }
}

class FontSizeNotifier extends StateNotifier<double> {
  final SettingsService _settings;

  FontSizeNotifier(this._settings) : super(_settings.getFontSize());

  Future<void> setFontSize(double size) async {
    await _settings.setFontSize(size);
    state = size;
  }
}

class LanguageNotifier extends StateNotifier<String> {
  final SettingsService _settings;

  LanguageNotifier(this._settings) : super(_settings.getLanguage());

  Future<void> setLanguage(String language) async {
    await _settings.setLanguage(language);
    state = language;
  }
}

class NotificationsNotifier extends StateNotifier<bool> {
  final SettingsService _settings;

  NotificationsNotifier(this._settings) : super(_settings.getNotificationsEnabled());

  Future<void> setEnabled(bool enabled) async {
    await _settings.setNotificationsEnabled(enabled);
    state = enabled;
  }
}