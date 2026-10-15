import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences.dart';

@immutable
class AppSettings {
  const AppSettings({this.locale, this.themeMode = ThemeMode.system});

  /// Null means "follow the device language".
  final Locale? locale;
  final ThemeMode themeMode;
}

class SettingsController extends Notifier<AppSettings> {
  static const _localeKey = 'settings.locale';
  static const _themeKey = 'settings.theme';

  @override
  AppSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(_localeKey);
    final theme = prefs.getString(_themeKey);
    return AppSettings(
      locale: code == null ? null : Locale(code),
      themeMode: ThemeMode.values.asNameMap()[theme] ?? ThemeMode.system,
    );
  }

  void setLocale(Locale locale) {
    state = AppSettings(locale: locale, themeMode: state.themeMode);
    ref.read(sharedPreferencesProvider).setString(_localeKey, locale.languageCode);
  }

  void setThemeMode(ThemeMode mode) {
    state = AppSettings(locale: state.locale, themeMode: mode);
    ref.read(sharedPreferencesProvider).setString(_themeKey, mode.name);
  }
}

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
