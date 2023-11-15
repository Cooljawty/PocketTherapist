import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart' as settings;

enum ThemeOption {
  light,
  highContrastLight,
  dark,
  highContrastDark,
}

class ThemeSettings with ChangeNotifier {
  // To change the theme
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primaryColor: Colors.deepPurpleAccent,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent)
          .copyWith(
              brightness: Brightness.dark,
              background: Colors.deepPurple.shade700,
              onBackground: Colors.deepPurpleAccent,
              primary: Colors.deepPurpleAccent),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
      ));

  /*
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: Colors.deepPurpleAccent,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent)
        .copyWith(
            brightness: Brightness.dark,
            background: Colors.deepPurple.shade700,
            primary: Colors.deepPurpleAccent),*/
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

  static ThemeData lightTheme = ThemeData(
    //Theme used for customizing backbuttonicon but overide function to obtain
    //actionIconTheme: ,

    //light app bar theme, currently app Bar is not used by pages but option is there
    //appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),

    //applies semi-transparent overlay color on materials to indicate elevation
    applyElevationOverlayColor: true,

    //defines theme used for BottomNavigationBar, note our framework deploys a regular navBar but we could could adopt this change
    //bottomNavigationBarTheme:BottomNavigationBarThemeData(backgroundColor: Colors.pink),

    brightness: Brightness.light,

    //Theme defines the default for button widgets like dropDownbutton and buttonBar, note we do not yet either of these
    //buttonTheme: ButtonThemeData(buttonColor: Colors.pink),

    //updates default color of MaterialType.canvas Material, not seen used
    //canvasColor: Colors.deepPurple,

    //Card color and theme is used to set the default of the Card widget class
    //cardColor: Colors.pink,
    cardTheme: CardTheme(
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.deepPurple.shade800,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        )),

    //TODO has not been tested but should be added since check box is used in tags
    //checkboxTheme: ,
    //Set of 30 colors that can be used to customize widgets further if needed
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB388FF)).copyWith(
        //these can be accessed by widgets to set their color to match the light theme
        //used with standardButton
        brightness: Brightness.light,
        background: Colors.white,
        onBackground: Colors.deepPurple,
        primary: Colors.deepPurpleAccent[100],
        //color of hint validation text in text fields
        error: Colors.red),

    //If we opt to use the built in date picker to create a plan entry then we can configure
    //the color scheme with the theme below
    //datePickerTheme: ,

    //the Alert Dialog widget light theme, handles color scheme for Dialouge elements like alertDialouge
    dialogBackgroundColor: Colors.deepPurpleAccent,
    //DialogTheme will set the theme for all Dialog elements but also overwrites the background color above
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.deepPurpleAccent,
      //covers the text style for the top part of the dialog box, textstyle is body medium by default
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    ),

    //dividerColor and divider theme might be useful if we opt to use dividers

    //TODO theme for customizing dropdownmenu widgets, does not currently work but is needed
    /*dropdownMenuTheme: DropdownMenuThemeData(
        //textStyle: , by default textstyle is set to lightTheme.textTheme
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
        ),
        inputDecorationTheme: InputDecorationTheme(fillColor: Colors.pink)),
*/
    //light elevated button theme, controls the default look of all elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade100),
      shadowColor: MaterialStateProperty.all<Color>(Colors.black),
      //color of the text of elevated button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      //default will be used but can be overwritten to give text better sizing
      textStyle: MaterialStateProperty.all<TextStyle>(defaultTextStyle()),
    )),

    //light floating button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepPurple.shade700,
        //shape will be circular by default
        shape: const CircleBorder(eccentricity: 1.0)),

    //used to set the default color of the hint text in Textfields
    hintColor: Color.fromARGB(220, 0, 0, 0),
    //used to set default hover color for a component, does not currently work as color
    //is overwritten by other defaults
    //hoverColor: Colors.pink,

    //IconButton is used in fields.dart so override to control its color scheme
    //iconButtonTheme: IconButtonThemeData(),
    //set the icon theme, I think the icon colors are being overwritten by parent widget
    /*iconTheme: IconThemeData(
      color: Colors.pink,
    ),*/
    //indicator color is the default color of the selected tab in the tab bar
    //indicatorColor: Colors.pink,

    //default input decoration for Textfield and TextformField, side note also effects dropdown menu
    /*inputDecorationTheme:
        InputDecorationTheme(fillColor: Colors.blue, filled: true),*/

    //default light theme for the navigation bar
    //navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.pink),
    //navigationDrawerTheme

    //will be used later to add in the page transitions
    //pageTransitionsTheme: ,

    //The background color for major parts of the app (toolbars, tab bars), might not need
    primaryColor: Colors.deepPurple,
    primaryColorDark: const Color.fromARGB(255, 65, 36, 116),
    primaryColorLight: Colors.deepPurpleAccent,

    //defines the default color for the scaffold used to make the app, makes up the background
    scaffoldBackgroundColor: Colors.white,

    //A theme for customizing the colors, thickness, and shape of scrollbars, may end up using them
    //scrollBarTheme

    //The Material widget uses this default to draw elevation shadows
    shadowColor: Colors.black,

    //Theme used for creating default appearance of all Textbuttons
    //textButtonTheme
    //Used to set the theme of textField widgets, may be used instead of input decoration Theme
    //textSelectionTheme: ,

    //light text theme for all default widgets, should be used before declaring new text style
    textTheme: const TextTheme(
      //headline, title, body, and label are the default fonts so they are overwritten
      //the varients of each like headline# are not used by default
      titleSmall: TextStyle(
          color: Colors.green, fontSize: 25.0, fontWeight: FontWeight.bold),

      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
      //headlineMedium: TextStyle(color: Colors.pink, fontSize: 25.0, fontWeight: FontWeight.bold),
      //headlineSmall: TextStyle(color: Colors.pink, fontSize: 20.0, fontWeight: FontWeight.bold),

      bodyLarge: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
      //bodyMedium: TextStyle(color: Colors.orange, fontSize: 12.0, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(
          color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
    ),

    useMaterial3: true,
  );

  /*
  static ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB388FF) ).copyWith(
      brightness: Brightness.light,
      background: Colors.white,
      primary:  Colors.deepPurpleAccent[100]
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
  );*/

  static TextStyle defaultTextStyle(
          [double fontSize = 14.0, FontWeight fontWeight = FontWeight.bold]) =>
      TextStyle(fontSize: fontSize, fontWeight: fontWeight);

  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      color: Colors.black,
      blurRadius: 10,
      offset: Offset.fromDirection(2.5),
    ),
  ];

  String currentThemeName =
      settings.getCurrentTheme() == ThemeSettings.lightTheme ? 'Light' : 'Dark';
  ThemeData get theme => settings.getCurrentTheme();

  changeTheme(String theme) {
    ThemeOption selectedtheme = switch (theme) {
      "Light" => ThemeOption.light,
      "Dark" => ThemeOption.dark,
      _ => ThemeOption.dark,
    };
    settings.setTheme(selectedtheme);

    notifyListeners();
  }
}
