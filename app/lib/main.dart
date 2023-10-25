import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';

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
    return ChangeNotifierProvider(
        create: (context) => ThemeSettings(),
        builder: (context, child) {
          final provider = Provider.of<ThemeSettings>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: provider.theme,
            home: const DashboardPage(),
          );
        });
  }
}


// Used for displaying the splashscreen and then the dashboard, but when used with routes, causes
// Duplicate entries.
//

