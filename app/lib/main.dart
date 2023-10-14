import 'package:flutter/material.dart';
// ------------------- Pages ----------
import 'package:app/pages/settings.dart';
import 'package:app/pages/loading.dart';
import 'package:app/pages/calendar.dart';
import 'package:app/pages/entries.dart';
import 'package:app/pages/dashboard.dart';
import 'package:app/pages/plans.dart';

void main() {
  //Things that need to be done before the application is ran.
  runApp(RootApp());
}

class RootApp extends StatefulWidget {
  RootApp({super.key});

  // This will need to change eventually.

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          brightness: Brightness.light,
          background: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
              .copyWith(
                  brightness: Brightness.dark, background: Colors.black54),
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold))),
      home: DashboardPage()


    );
  }
}
//
// FutureBuilder(future: SettingsManager
//     .loadSettings(), builder: (context, snapshot) {
// if(snapshot.hasData) {
// return DashboardPage();
// }
// else if(snapshot.hasError) {
// // Do something with error.
// return Placeholder();
// } else {
// // still loading
// return SplashScreen();
// }
// }),
