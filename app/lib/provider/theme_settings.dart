import 'package:flutter/material.dart';

class ThemeSettings extends ChangeNotifier {
  String? currentTheme = 'system';

  ThemeMode get themeMode {
    if(currentTheme == 'Light'){
      return ThemeMode.light;
    }
    if(currentTheme == 'Dark'){
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  changeTheme(String? theme){
    currentTheme = theme;
    notifyListeners();
  }
}