import 'package:app/pages/calendar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
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
//
// class SettingsManager extends ChangeNotifier {
//
//     // This will be changed to load and parse the settings.yml file with dart.yml
//     static Future<void> loadSettings([String fileName= "settings.yml"]) {
//       return Future.delayed (
//         const Duration(seconds: 5),
//           () => {"This": 0}
//       );
//     }
//
// }
