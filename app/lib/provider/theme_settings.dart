import 'package:flutter/material.dart';

class ThemeSettings with ChangeNotifier {
  // To change the theme
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
        .copyWith(brightness: Brightness.dark, background: Colors.black54),
    // textTheme: TextTheme(
    //   displayLarge: defaultTextStyle(),
    //   displayMedium: defaultTextStyle(),
    //   displaySmall: defaultTextStyle(),
    //   headlineMedium: defaultTextStyle(),
    //   headlineSmall: defaultTextStyle(),
    //   titleLarge: defaultTextStyle(),
    //   titleMedium: defaultTextStyle(),
    //   titleSmall: defaultTextStyle(),
    //   bodyLarge: defaultTextStyle(),
    //   bodyMedium: defaultTextStyle(),
    //   bodySmall: defaultTextStyle(),
    //   labelLarge: defaultTextStyle(),
    //   labelSmall: defaultTextStyle(),
    // )
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
      brightness: Brightness.light,
      background: Colors.white,
    ),
    // textTheme: TextTheme(
    //   displayLarge: defaultTextStyle(),
    //   displayMedium: defaultTextStyle(),
    //   displaySmall: defaultTextStyle(),
    //   headlineMedium: defaultTextStyle(),
    //   headlineSmall: defaultTextStyle(),
    //   titleLarge: defaultTextStyle(),
    //   titleMedium: defaultTextStyle(),
    //   titleSmall: defaultTextStyle(),
    //   bodyLarge: defaultTextStyle(),
    //   bodyMedium: defaultTextStyle(),
    //   bodySmall: defaultTextStyle(),
    //   labelLarge: defaultTextStyle(),
    //   labelSmall: defaultTextStyle(),
    // )
  );

  static TextStyle defaultTextStyle(
          [Color color = Colors.white,
          double fontSize = 14.0,
          FontWeight fontWeight = FontWeight.bold]) =>
      TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);

  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      color: Colors.black,
      blurRadius: 10,
      offset: Offset.fromDirection(2.5),
    ),
  ];

  ThemeData _theme = lightTheme;
  ThemeData get theme => _theme;

  String? currentTheme = 'Light';

  getTheme() {
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
