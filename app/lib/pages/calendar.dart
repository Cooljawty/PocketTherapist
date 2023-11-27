import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter/material.dart';
import 'package:app/uiwidgets/calendar.dart';

/// [CalendarPage] is the page that displays tthe calendar and related mood
/// tracking information for the user.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
					child: Align(
						child: Column(
							children: [
								Calendar(),
							],
						),
					),
				),
			),
			bottomNavigationBar: CustomNavigationBar(selectedIndex: 3,)
		);
  }
}
