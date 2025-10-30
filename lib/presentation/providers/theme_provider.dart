import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }
  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('theme_mode') ?? 'system';
    if (s == 'light')
      state = ThemeMode.light;
    else if (s == 'dark')
      state = ThemeMode.dark;
    else
      state = ThemeMode.system;
  }

  Future<void> toggle() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      'theme_mode',
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
