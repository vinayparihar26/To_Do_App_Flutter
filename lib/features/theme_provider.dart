import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:to_do_app/setting_model.dart';

class ThemeProvider with ChangeNotifier {
  final Box<SettingModel> settingsBox = Hive.box<SettingModel>('setting');
  bool isDarkMode = false;

  Future<void> loadTheme() async{
    final savedSetting = settingsBox.get('theme');
    isDarkMode = savedSetting?.isDarkMode ?? false;
    notifyListeners();
  }

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toogleTheme() {
    isDarkMode = !isDarkMode;
    settingsBox.put('theme', SettingModel(isDarkMode: isDarkMode));
    notifyListeners();
  }


}
