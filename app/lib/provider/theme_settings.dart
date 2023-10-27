import 'package:flutter/material.dart';

class ThemeSettings with ChangeNotifier {
  // To change the theme
  static ThemeData darkTheme = ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
          .copyWith(brightness: Brightness.dark, background: Colors.black54),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold)),
      primaryColor: Colors.deepOrange
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme:
    ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
      brightness: Brightness.light,
      background: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold),
    ),
    primaryColor: Colors.deepPurple

  );


  ThemeData _theme = lightTheme;
  ThemeData get theme => _theme;

  String? currentTheme = 'Light';

  getTheme(){
    if (currentTheme == 'Light') {
      return 'Light';
    }
    if (currentTheme == 'Dark') {
      return 'Dark';
    }
  }


  changeTheme(String? theme) {
    currentTheme = theme;
    if (currentTheme == 'Light') {
      _theme = lightTheme;
    }
    if (currentTheme == 'Dark') {
      _theme = darkTheme;
    }

    notifyListeners();
  }
}
