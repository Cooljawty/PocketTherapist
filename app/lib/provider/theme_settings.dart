import 'package:flutter/material.dart';

class ThemeSettings with ChangeNotifier {
  // To change the theme
  static ThemeData darkTheme = ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
          .copyWith(
          brightness: Brightness.dark, background: Colors.black54),
      textTheme: const TextTheme(
        bodySmall:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold
        ),
        displaySmall: TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold
        ),
        bodyMedium: TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
              fontWeight: FontWeight.bold
        ),
        displayMedium: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        bodyLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        displayLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        labelLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        titleLarge: TextStyle(
            color: Colors.blueGrey,
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
      )
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme:
    ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
      brightness: Brightness.light,
      background: Colors.white,
    ),
      textTheme: const TextTheme(
        bodySmall:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold
        ),
        displaySmall: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold
        ),
        bodyMedium: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        displayMedium: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        bodyLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        displayLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        labelLarge:  TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        titleLarge: TextStyle(
            color: Colors.blueGrey,
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
      )
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
