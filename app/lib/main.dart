import 'package:app/pages/calendar.dart';
import 'package:app/pages/dashboard.dart';
import 'package:app/pages/entries.dart';
import 'package:app/pages/new_entry.dart';
import 'package:app/pages/plans.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/entry.dart' as entry;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()  {
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
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: _load(),
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done ? ChangeNotifierProvider<ThemeSettings>(
          create: (context) => ThemeSettings(),
          builder: (context, child) {
            final provider = Provider.of<ThemeSettings>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: provider.theme,
              routes: {
                "Calendar": (context) => const CalendarPage(),
                "Dashboard": (context) => const DashboardPage(),
                "Entries":(context) => const EntryPanelPage(),
                "Plans": (context) => const PlansPage(),
                "Settings": (context) => const SettingsPage(),
                "Welcome": (context) => const WelcomePage(),
                "Tags": (context) => const TagSettingsPage(),
                "NewEntry": (context) => const NewEntryPage(),
                // "Emotions": (context) => const EmotionSettingsPage(),
              },
              initialRoute: "Welcome",
            );
          }) : const Directionality(textDirection: TextDirection.ltr, child: Center(child: CircularProgressIndicator())),
    );

  }

  _handleTransition(String state )  {
    switch(state){
    case 'show': break;
    case 'resume': break;
    case 'inactive': break;
    case 'hide': break;
    case 'pause':
      _save();
      break;
    case 'detach': break;
    case 'restart': break;
    }
  }

  void _handleStateChange(AppLifecycleState value) {
    //TODO: Handle things that arent defual
  }

  Future<void> _load() async {
    await settings.load();
    // Add more here as needed..

    settings.setInitialized();
  }

  Future<void> _save() async {
    await settings.save();
  }
}

