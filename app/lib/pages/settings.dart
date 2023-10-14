import 'package:app/pages/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => SettingsPage());
  }
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Text('Settings'),
              ElevatedButton(onPressed: (){

                Navigator.of(context).pushReplacement(CalendarPage.route());

              }, child: const Text('nextPageCalendar') )
            ],
          ),
        )
    );
  }
}

// class SettingsManager extends ChangeNotifier {
//
//     Map<String, Object> _settings = {};
//     ThemeMode _currentMode = SchedulerBinding.instance.platformDispatcher
//         .platformBrightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;
//
//     // This will be changed to load and parse the settings.yml file with dart.yml
//     static Future<void> loadSettings([String fileName= "settings.yml"]) {
//       return Future.delayed (
//         const Duration(seconds: 5),
//           () => {"This": 0}
//       );
//     }
//
//     void toggleDarkMode() {
//       _currentMode =
//       (_currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
//     }
//
//     bool isDarkmode() => (_currentMode == ThemeMode.dark);
// }
