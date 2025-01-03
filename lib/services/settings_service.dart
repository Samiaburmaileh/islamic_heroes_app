import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  // Theme Mode
  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
          (e) => e.toString() == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.toString());
  }

  // Font Size
  double getFontSize() {
    return _prefs.getDouble(_fontSizeKey) ?? 1.0;
  }

  Future<void> setFontSize(double size) async {
    await _prefs.setDouble(_fontSizeKey, size);
  }

  // Language
  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'English';
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  // Notifications
  bool getNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  // Clear all settings
  Future<void> clearSettings() async {
    await Future.wait([
      _prefs.remove(_themeKey),
      _prefs.remove(_fontSizeKey),
      _prefs.remove(_languageKey),
      _prefs.remove(_notificationsKey),
    ]);
  }
}