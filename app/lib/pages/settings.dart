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

