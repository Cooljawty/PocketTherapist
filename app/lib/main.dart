import 'package:flutter/material.dart';
import 'package:app/pages/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';

void main() async{
  //Things that need to be done before the application is ran.
 // final SettingsManager settings = SettingsManager();
  // await preInit(settings);
  runApp(const RootApp(/*settings: settings*/));
}

// Future<void> preInit(SettingsManager settings) async {}


/// This is the root application
/// It contains the main functions and loading that will be necessary for
/// the rest of the application to run.
class RootApp extends StatefulWidget {
  const RootApp({
    super.key,
  });

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
        }
    );
  }
}
