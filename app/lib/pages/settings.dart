import 'package:app/pages/calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';

class SettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Drop down menu items
  List<String> themeStrings = ['Dark', 'Light'];
  String? chosenTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeSettings>(context);
    return Scaffold(
        // Invisible app bar
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Create a drop down menu to choose a theme
              SizedBox(
                  // Fixed size to make it the same as main menu
                  width: 240,
                  child: Container(
                      // Make the grey background
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                          // Dropdown field
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              // Add icons based on theme
                              prefixIcon: Icon(chosenTheme == 'Dark' ? Icons.brightness_2 : Icons.brightness_5_outlined),
                                  //Theme.of(context).brightness == Brightness.dark? Icons.brightness_2 : Icons.brightness_5_outlined),
                            ),
                            // Make the grey background
                            dropdownColor: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0),
                            // Set up the dropdown menu items
                            value: chosenTheme,
                            items: themeStrings
                                .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(color: Colors.black),
                                    )))
                                .toList(),
                            // if changed set the new theme
                            onChanged: (item) => setState(() {
                              chosenTheme = item;
                              provider.changeTheme(chosenTheme);
                            }),
                            // Use Cupertino to change the theme data for the other pages
                          )
                      )),
              const Spacer(
                flex: 1,
              ),
              /*
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(CalendarPage.route());
              }, child: const Text('nextPageCalendar') )
              */
            ],
          ),
        ));
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
