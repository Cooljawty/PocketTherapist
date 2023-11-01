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
			body: const SafeArea(
				child: Column(
					children: [
						Text('Calendar'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 2,
				destinations: [
					destinations['dashboard']!,
					destinations['entries']!,
					destinations['calendar']!,
					destinations['settings']!,
				],
			),
    );
  }
}
