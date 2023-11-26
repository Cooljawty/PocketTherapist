import 'package:app/uiwidgets/emotion_chart.dart';
import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:app/helper/classes.dart';
import 'package:app/provider/settings.dart' as settings;

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
						EmotionGraph(startDate: DateTime(2023, 1, 1), endDate: DateTime(2023, 1, 7), type: settings.getEmotionGraphType()),
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
