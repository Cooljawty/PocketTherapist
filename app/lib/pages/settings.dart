import 'package:app/pages/calendar.dart';
import 'package:flutter/material.dart';
import 'package:app/helper/file_manager.dart';

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
          minimum: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Settings'),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushReplacement(CalendarPage.route());
                }, child: const Text('nextPageCalendar') ),
                InkWell(
                  onTap: loadFile,
                  child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.all(Radius.circular(15.0))),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Open Vault File")
                      )
                  ),
                )
              ],
            ),
          )
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
