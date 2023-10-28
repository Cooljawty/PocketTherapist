import 'package:app/pages/welcome.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //Things that need to be done before the application is ran.
  runApp(const RootApp());
}

/// This is the root application
/// It contains the main functions and loading that will be necessary for
/// the rest of the application to run.
class RootApp extends StatefulWidget {
  const RootApp({super.key}) ;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init().then((value) {setState(() {
      isLoading = false;
    });});
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeSettings(),
        builder: (context, child) {
          final provider = Provider.of<ThemeSettings>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: provider.theme,
            home: isLoading? const Placeholder() : const WelcomePage(),
          );
        });
  }
}

Future<void> init() async {
  SharedPreferences.setPrefix(settings.prefrencesPrefix);
  await settings.init(); // init by default for settings
}