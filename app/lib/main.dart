import 'package:app/pages/welcome.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
class RootApp extends StatefulWidget {
  const RootApp({super.key}) ;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp>  {
  late final AppLifecycleListener _listener;
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () => _handleTransition('show'),
      onResume: () => _handleTransition('resume'),
      onHide: () => _handleTransition('hide'),
      onInactive: () => _handleTransition('inactive'),
      onPause: () => _handleTransition('pause'),
      onDetach: () => _handleTransition('detach'),
      onRestart: () => _handleTransition('restart'),
      // This fires for each state change. Callbacks above fire only for
      // specific state transitions.
      onStateChange: _handleStateChange,
    );
  }

  @override
  void dispose() {
    _state = null;
    _listener.dispose();
    super.dispose();
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
            routes: {
              'splash': (_) => const Splash(),
              'app': (_) => const WelcomePage(),
            },
            initialRoute: 'splash',
          );
        });
  }

  _handleTransition(String state )  {
    switch(state){
    case 'show': break;
    case 'resume': break;
    case 'inactive': break;
    case 'hide': break;
    case 'pause':
      settings.save().then((value) => null);
      debugPrint("Saving settings");
      break; break;
    case 'detach': break;
    case 'restart': break;
    }
  }

  void _handleStateChange(AppLifecycleState value) {
    //TODO: Handle things that arent defual
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
    settings.load().then((_) => Navigator.pushReplacementNamed(context, 'app'));
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('somewhereovertherainbow'));
  }
}
