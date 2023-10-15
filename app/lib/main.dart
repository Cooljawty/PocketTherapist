import 'package:flutter/material.dart';
import 'package:app/pages/dashboard.dart';

void main() {
  //Things that need to be done before the application is ran.
  // await initialization(null);
  runApp(const RootApp());
}
//
// Future initialization(BuildContext? context) async {
//
// }

/// This is the root application
/// It contains
class RootApp extends StatefulWidget {
  const RootApp({super.key});

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
      home: const DashboardPage(),
    );
  }
}


// Used for displaying the splashscreen and then the dashboard, but when used with routes, causes
// Duplicate entries.
//

