import 'package:app/pages/welcome.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yaml/yaml.dart';

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
        }
    );
  }
}

Future<void> init() async {
  String quoteFileContent = await rootBundle.loadString('assets/quotes.yml');
  quotes = loadYaml(quoteFileContent)['Quotes'];
  //settings.init(); // init by default for settings
  //Encryptor(); // Init by default for encryptor
}