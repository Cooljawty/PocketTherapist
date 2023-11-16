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
    //can be used to customize back button icon, left default
    //actionIconTheme: ,

    //light app bar theme
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),

    //applies semi-transparent overlay color on materials to indicate elevation
    applyElevationOverlayColor: true,

    //defines theme used for BottomNavigationBar, note our app deploys a regular navBar but we could could adopt this change
    //bottomNavigationBarTheme:BottomNavigationBarThemeData(backgroundColor: Colors.deepPurple),

    brightness: Brightness.light,

    //Theme defines the default for button widgets like dropDownbutton and buttonBar, note we do not yet use either of these
    buttonTheme: const ButtonThemeData(buttonColor: Colors.deepPurple),

    //updates default color of MaterialType.canvas Material, used to control color of drop down menu items
    canvasColor: Colors.grey.shade300,

    //Card color and theme is used to set the default of the Card widget class
    //cardColor: Colors.deepPurple, //The color of Material when it is used as a card
    cardTheme: CardTheme(
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.deepPurple.shade800,
            width: 3.0,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        )),

    //Controls the appearence and layout of checkbox widgets
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(Colors.deepPurple.shade100),
      checkColor: MaterialStateProperty.all<Color>(Colors.black),
      //note: must be overwritten with MaterialStateBorderSide for affect to apply to box while box is true
      side: const BorderSide(
        color: Colors.black,
        width: 2.0,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    ),

    //Set of 30 colors that can be used to customize widgets further if needed
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB388FF)).copyWith(
        //these can be accessed by widgets to set their color to match the light theme
        //used with standardButton
        brightness: Brightness.light,
        background: Colors.white,
        onBackground: Colors.deepPurple,
        primary: Colors.deepPurpleAccent[100],
        primaryContainer: Colors.deepPurpleAccent,
        //color of hint validation text in text fields
        error: Colors.red),

    //If we opt to use the built in date picker to create a plan entry then we can configure
    //the color scheme with the theme below
    //datePickerTheme: ,

    //the Alert Dialog widget light theme, handles color scheme for Dialouge elements like alertDialouge
    dialogBackgroundColor: Colors.deepPurpleAccent,
    //DialogTheme will set the theme for all Dialog elements but also overwrites the background color above
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.deepPurple,
      elevation: 20.0,
      shadowColor: Colors.black,
      //covers the text style for the top part of the dialog box, textstyle is body medium by default
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    ),

    //dividerColor and divider theme might be useful if we opt to use dividers

    //theme for customizing dropdownmenu widgets, does not affect DropdownButtonFormField
    dropdownMenuTheme: DropdownMenuThemeData(
        //textStyle: , by default textstyle is set to lightTheme.textTheme
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.deepPurple, filled: true)),

    //light elevated button theme, controls the default look of all elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade100),
      elevation: MaterialStateProperty.all<double?>(10.0),
      //color of the text of elevated button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      //fixed sized initially set to match standardElevatedButton size
      fixedSize: MaterialStateProperty.all<Size>(const Size(350, 50)),
      //default will be used but can be overwritten to give text better sizing
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
      shadowColor: MaterialStateProperty.all<Color>(Colors.black),
    )),

    //light floating button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        //shape will be circular by default
        shape: CircleBorder(eccentricity: 1.0)),

    //used to set the default color of the hint text in Textfields
    hintColor: const Color.fromARGB(220, 0, 0, 0),

    //IconButton theme is used in fields.dart so override to control its color scheme
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
      elevation: MaterialStatePropertyAll(10.0),
      foregroundColor: MaterialStatePropertyAll(Colors.grey),
    )),
    //icon theme
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),

    //default input decoration for Textfield, TextformField, and DropdownButtonFormField
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.grey,
      filled: true,
    ),

    //default light theme for the navigation bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.deepPurple.shade300,
      iconTheme:
          const MaterialStatePropertyAll(IconThemeData(color: Colors.black)),
      indicatorColor: Colors.white,
    ),
    //navigationDrawerTheme

    //will be used to add page transitions after front end is done
    //pageTransitionsTheme: ,

    //The background color for major parts of the app (toolbars, tab bars)
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
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStatePropertyAll(Colors.deepPurpleAccent.withOpacity(0.5)),
      foregroundColor: const MaterialStatePropertyAll(Colors.black),
    )),

    //Used to set the theme of content selected within a textField widgets
    textSelectionTheme:
        TextSelectionThemeData(selectionColor: Colors.deepPurple.shade100),

    //light text theme for all default widgets, should be used before declaring new text style
    textTheme: const TextTheme(
      //headline, title, body, and label are the default fonts so they are overwritten
      //the varients of each like headline# are not used by default
      labelLarge: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
      labelMedium: TextStyle(
          color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.normal),
      labelSmall: TextStyle(
          color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.normal),
      titleLarge: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 32.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(
          color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w500),
    ),

    useMaterial3: true,
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
