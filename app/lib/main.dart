import 'package:app/pages/welcome.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //Things that need to be done before the application is ran.
  WidgetsFlutterBinding.ensureInitialized();
  //updated to load settings before displaying app
  settings.load().whenComplete(() => runApp(const RootApp()));
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
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
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
    //is loaded before app init state
    //settings.load().whenComplete(() => null);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeSettings>(
        create: (context) => ThemeSettings(),
        builder: (context, child) {
          final provider = Provider.of<ThemeSettings>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: provider.theme,
            home: const WelcomePage(),
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
      settings.save().whenComplete(() => null);
      break;
    case 'detach': break;
    case 'restart': break;
    }
  }

  void _handleStateChange(AppLifecycleState value) {
    //TODO: Handle things that arent defual
  }
}
