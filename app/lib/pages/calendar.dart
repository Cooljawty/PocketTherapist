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
		final firstOfTheMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
		final lastOfTheMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(Duration(days: 1));
    return Scaffold(
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
					child: Align(
						child: Column(
							children: [
								Calendar(startDate: firstOfTheMonth, endDate: lastOfTheMonth),
							],
						),
					),
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
