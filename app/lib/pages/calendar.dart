import 'package:app/uiwidgets/navbar.dart';
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
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 2,
				destinations: [
					Destinations['dashboard']!,
					Destinations['entries']!,
					Destinations['calendar']!,
					Destinations['settings']!,
				],
			),
    );
  }
}
