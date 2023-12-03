import 'package:app/uiwidgets/calendar.dart';
import 'package:app/uiwidgets/decorations.dart';
import 'package:app/uiwidgets/emotion_chart.dart';
import 'package:flutter/material.dart';

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
				child: Column(
					children: [
						const Text('Calendar'),
						Padding(
							padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
							child: Align(
								child: Column(
									children: [
										const Calendar(),
										EmotionGraph(startDate: DateTime(2023, 1, 1), endDate: DateTime(2023, 1, 7)),
									],
								),
							),
						),
					],
				),
			),
			bottomNavigationBar: CustomNavigationBar(selectedIndex: 3,),
		);
  }
}
