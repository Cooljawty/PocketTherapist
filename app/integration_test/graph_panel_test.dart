import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/main.dart' as app;
import 'package:app/uiwidgets/emotion_chart.dart';
import 'package:app/provider/settings.dart' as settings;

import 'test_utils.dart';

void main() {
  testWidgets('Displaying emotion time chart', (tester) async {
		//Navigate to graph page
		await startSkipFrontScreen(tester);
		await pumpUntilFound(tester, find.byKey(const Key("navCalendar")), true);
		await tap(tester, find.byKey(const Key("navCalendar")), true);

		//Two graphs should exist
		expect(find.byType(EmotionGraph), findsOneWidget);

		//Check time chart
		final emotionGraph = find.byType(LineChart);
		expect(emotionGraph, findsOneWidget);
	});

  testWidgets('Displaying emotion frequency chart', (tester) async {
		await startAppWithSettings(tester, {
			settings.configuredKey: true,
			settings.encryptionToggleKey: false,
			settings.emotionGraphTypeKey: GraphTypes.frequency.toString()
		});

		// Enter the app
		Finder startButton = find.byKey(const Key("Start_Button"));
		await pumpUntilFound(tester, startButton);
		await tap(tester, startButton);


		await pumpUntilFound(tester, find.byKey(const Key("navCalendar")), true);
		await tap(tester, find.byKey(const Key("navCalendar")), true);
		await tester.pumpAndSettle();
		//Two graphs should exist
		expect(find.byType(EmotionGraph), findsOneWidget);

		//Check time chart
		final emotionGraph = find.byType(RadarChart);
		expect(emotionGraph, findsOneWidget);
	});
}
