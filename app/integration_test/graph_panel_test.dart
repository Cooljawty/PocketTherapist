import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/pages/entry.dart';
import 'package:app/uiwidgets/emotion_chart.dart';

void main() {
  late Widget myApp;

	/*
	const testEntries = <JournalEntry>[
    JournalEntry(
			title: "Day one entry 1", entryText: "", 
			date: DateTime(2023, 1, 1) 
			tags: [],
		),
    JournalEntry(
			title: "Day one entry 2", entryText: "", 
			date: DateTime(2023, 1, 1) 
			tags: [],
		),
    JournalEntry(
			title: "", entryText: "", 
			date: DateTime(2023, 1, 2) 
			tags: [],
		),
    JournalEntry(
			title: "Day thrree entry 1", entryText: "", 
			date: DateTime(2023, 1, 3) 
			tags: [],
		),
    JournalEntry(
			title: "Day thrree entry 2", entryText: "", 
			date: DateTime(2023, 1, 3) 
			tags: [],
		),
    JournalEntry(
			title: "", entryText: "", 
			date: DateTime(2023, 1, 4) 
			tags: [],
		),
    JournalEntry(
			title: "", entryText: "", 
			date: DateTime(2023, 1, 5) 
			tags: [],
		),
    JournalEntry(
			title: "Out of range entry", entryText: "", 
			date: DateTime(2023, 1, 14) 
			tags: [],
		),
	];
	*/

  setUp(() {
    myApp = MaterialApp(
      home: Scaffold(
				body: SafeArea(
					child: Column(
						children: [
							EmotionGraph(
								key: const Key('Time graph'), 
								startDate: DateTime(2023, 12, 1),
								endDate:DateTime(2023, 12, 7),
								type: GraphTypes.time
							),
							EmotionGraph(
								key: const Key('Frequency graph'), 
								startDate: DateTime(2023, 12, 1),
								endDate:DateTime(2023, 12, 7),
								type: GraphTypes.frequency
							),
						],
					)
				)
			)
		);
  });

  testWidgets('Displaying emotion time chart', (tester) async {
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

		//Two graphs should exist
		expect(find.byType(EmotionGraph), findsNWidgets(2));

		//Check time chart
		final timeGraph = find.byType(LineChart);
		expect(timeGraph, findsOneWidget);
		//Check labels
		//Check axies

		//Check frequency chart
		final frequencyGraph = find.byType(RadarChart);
		expect(frequencyGraph, findsOneWidget);
		//Check labels
		//Check axies
	});

}
