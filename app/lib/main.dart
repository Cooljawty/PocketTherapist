import 'package:flutter/material.dart';
import 'package:app/pages/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:yaml/yaml.dart';
import 'package:app/uiwidgets/decorations.dart';

void main() {
  //Things that need to be done before the application is ran.
  runApp(const RootApp());
}

Future<void> init() async {
  String quoteFileContent = await rootBundle.loadString('assets/quotes.yml');
  Quote.quotes = loadYaml(quoteFileContent)['Quotes'];
  await Future.delayed(const Duration(seconds: 5));
  //SettingsManager(); // init by default for settings
  //Encryptor(); // Init by default for encryptor
}


/// This is the root application
/// It contains the main functions and loading that will be necessary for
/// the rest of the application to run.
class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

 //   init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeSettings(),
        builder: (context, child) {
          final provider = Provider.of<ThemeSettings>(context);
          return FutureBuilder(
              future: init(),
              builder: (context, snapshot) {
                if(snapshot.hasError) {
                  return const Placeholder();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    themeMode: ThemeMode.system,
                    theme: provider.theme,
                    home: const DashboardPage(),
                  );
                } else {
                  return const LoadingAnimation();
                }
              }
          );
        }
    );
  }
}
