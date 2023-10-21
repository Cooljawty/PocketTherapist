import 'dart:ffi';

import 'package:flutter/material.dart';

class ThemeSettings extends ChangeNotifier {
  // To change the theme
  ThemeData _theme = ThemeData.dark();
  ThemeData get theme => _theme;

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
    if(currentTheme == 'Light'){
      _theme = ThemeData.light();
    }
    if(currentTheme == 'Dark'){
      _theme = ThemeData.dark();
    }
    notifyListeners();
  }
}