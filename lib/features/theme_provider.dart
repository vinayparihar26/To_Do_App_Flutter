import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
 bool isDarkMode = false;
  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toogleTheme(){
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
