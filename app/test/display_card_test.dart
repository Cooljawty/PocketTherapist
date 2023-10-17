import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';

void main() {
	const content = [
		{ "title": "Title of entry", "body": "Body of entry"},
		{ "title": "Title of entry", "body": "Body of entry"},
		{ "title": "Title of entry", "body": "Body of entry"},
	];

	late Widget myApp;
  setUp(() => {
    myApp = const MaterialApp(
			home: Scaffold(
				body: SafeArea(
					child: Column(
						children: [
							DisplayCard(content: content),
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

	testWidgets('All content items are displayed', (tester) async {
		await tester.pumpWidget(myApp);

		final entryTitleFinder = find.text("Title of entry");
		final entryBodyFinder = find.text("Body of entry");

		expect(entryTitleFinder, findsNWidgets(3));
		expect(entryBodyFinder, findsNWidgets(3));
	});
}
