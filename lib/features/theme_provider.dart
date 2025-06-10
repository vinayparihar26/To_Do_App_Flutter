import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:to_do_app/setting_model.dart';

class ThemeProvider with ChangeNotifier {
  final Box<SettingModel> settingsBox = Hive.box<SettingModel>('setting');
  bool isDarkMode = false;

  ThemeProvider() {
    _loadTheme(); // Load theme from Hive on init
  }
  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toogleTheme() {
    isDarkMode = !isDarkMode;
    
    settingsBox.put('theme', SettingModel(isDarkMode: !isDarkMode));
    notifyListeners();
  }

  void _loadTheme() {
    final savedSetting = settingsBox.get('theme');
    isDarkMode = savedSetting?.isDarkMode ?? false;
  }
}
