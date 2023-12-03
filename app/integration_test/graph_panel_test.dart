import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/main.dart' as app;
import 'package:app/uiwidgets/emotion_chart.dart';
import 'package:app/provider/settings.dart' as settings;

void main() {

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  });

  tearDown(() async {
    await settings.reset();
  });


  testWidgets('Displaying emotion time chart', (tester) async {
    app.main();
		await tester.pump();

		settings.setMockValues({
			'emotions': {
				'Anger': Colors.red,
				'Sad': Colors.blue,
				'Happy': Colors.green,
			},
			'emotionGraphType': GraphTypes.time.toString(),
			'configured': true,
			'encryption': false,
		});
		await tester.pump();

		//Navigate to graph page
		await tester.tap(find.byKey(const Key("Start_Button")));
    await tester.pumpAndSettle();
		await tester.tap(find.byKey(const Key("Navbar_Destination_Calendar")));
    await tester.pumpAndSettle();

		//Two graphs should exist
		expect(find.byType(EmotionGraph), findsOneWidget);

		//Check time chart
		final emotionGraph = find.byType(LineChart);
		expect(emotionGraph, findsOneWidget);
	});

  testWidgets('Displaying emotion frequency chart', (tester) async {
    app.main();
		await tester.pump();

		settings.setMockValues({
			'emotions': {
				'Anger': Colors.red,
				'Sad': Colors.blue,
				'Happy': Colors.green,
			},
			'emotionGraphType': GraphTypes.frequency.toString(),
			'configured': true,
			'encryption': false,
		});
		await tester.pump();

		//Navigate to graph page
		await tester.tap(find.byKey(const Key("Start_Button")));
    await tester.pumpAndSettle();
		await tester.tap(find.byKey(const Key("Navbar_Destination_Calendar")));
    await tester.pumpAndSettle();

		//Two graphs should exist
		expect(find.byType(EmotionGraph), findsOneWidget);

		//Check time chart
		final emotionGraph = find.byType(RadarChart);
		expect(emotionGraph, findsOneWidget);
	});

}
