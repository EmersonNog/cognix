import 'package:flutter/material.dart';

import '../services/local/theme_storage.dart';

enum AppThemePreference {
  system,
  light,
  dark;

  String get storageValue => switch (this) {
    AppThemePreference.system => 'system',
    AppThemePreference.light => 'light',
    AppThemePreference.dark => 'dark',
  };

  String get label => switch (this) {
    AppThemePreference.system => 'Usar o sistema',
    AppThemePreference.light => 'Modo claro',
    AppThemePreference.dark => 'Modo escuro',
  };

  ThemeMode get themeMode => switch (this) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };

  static AppThemePreference fromStorage(String? value) {
    return AppThemePreference.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => AppThemePreference.dark,
    );
  }
}

class AppThemeController extends ChangeNotifier {
  AppThemePreference _preference = AppThemePreference.dark;

  AppThemePreference get preference => _preference;
  ThemeMode get themeMode => _preference.themeMode;

  Future<void> load() async {
    _preference = AppThemePreference.fromStorage(
      await ThemeStorage.readPreference(),
    );
    notifyListeners();
  }

  Future<void> setPreference(AppThemePreference preference) async {
    if (_preference == preference) {
      return;
    }

    _preference = preference;
    notifyListeners();
    await ThemeStorage.savePreference(preference.storageValue);
  }
}
