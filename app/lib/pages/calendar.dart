import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:app/uiwidgets/calendar.dart';

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
						Text('Calendar'),
						Calendar(startDate: DateTime(2023, 1, 1), endDate: DateTime(2023, 1, 31)),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 2,
				destinations: [
					destinations['dashboard']!,
					destinations['entries']!,
					destinations['calendar']!,
					destinations['plans']!,
					destinations['settings']!,
				],
			),
    );
  }
}
