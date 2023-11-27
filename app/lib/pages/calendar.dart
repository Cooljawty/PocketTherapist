import 'package:app/uiwidgets/emotion_chart.dart';
import 'package:app/uiwidgets/decorations.dart';
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
						Text('Calendar'),
						EmotionGraph(startDate: DateTime(2023, 1, 1), endDate: DateTime(2023, 1, 7)),
					],
				),
			),
			bottomNavigationBar: CustomNavigationBar(selectedIndex: 3,)
		);
  }
}
