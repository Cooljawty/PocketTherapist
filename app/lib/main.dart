import 'package:app/pages/welcome.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //Things that need to be done before the application is ran.

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

/// This is the root application
/// It contains the main functions and loading that will be necessary for
/// the rest of the application to run.
class RootApp extends StatelessWidget {
  const RootApp({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeSettings(),
        builder: (context, child) {
          final provider = Provider.of<ThemeSettings>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: provider.theme,
            routes: {
              'splash': (_) => const Splash(),
              'app': (_) => const WelcomePage(),
            },
            initialRoute: 'splash',
          );
        });
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    SharedPreferences.setPrefix(settings.prefrencesPrefix);
    settings.init().then((_) => Navigator.pushReplacementNamed(context, 'app'));
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('somewhereovertherainbow'));
  }
}
