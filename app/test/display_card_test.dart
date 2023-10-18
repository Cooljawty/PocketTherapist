import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';

void main() {
	const entry = { "title": "Title of entry", "previewText": "Preview of entry"};

	late Widget myApp;
  setUp(() => {
    myApp = const MaterialApp(
			home: Scaffold(
				body: SafeArea(
					child: Column(
						children: [
							DisplayCard(entry: entry),
						],
					),
				)
			)
		)
	});

	testWidgets('Test the DisplayCard constructor', (tester) async {
		await tester.pumpWidget(myApp);

		final cardFinder = find.byType(DisplayCard);
		expect(cardFinder, findsOneWidget);
	});

	testWidgets('Content of entry is displayed on DisplayCard', (tester) async {
		await tester.pumpWidget(myApp);

		final entryTitleFinder = find.text("Title of entry");
		final entryPreviewFinder = find.text("Preview of entry");

		expect(entryTitleFinder, findsOneWidget);
		expect(entryPreviewFinder, findsOneWidget);
	});
}
