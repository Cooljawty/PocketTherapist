import 'package:pocket_therapist/pages/dashboard.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  // This is the static route for drawing this page
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const CalendarPage());
  }
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}


class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Text('Calendar'),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(DashboardPage.route());
              },
              child: const Text('nextPageDashboard'))
            ],
          ),
        )
    );
  }
}
