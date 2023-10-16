import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';

void main() {
	const content = ["Entry","Entry","Entry",];

	late Widget myApp;
  setUp(() => {
		myApp = const MaterialApp(
			home: Scaffold(
				body: SafeArea(
					child: DisplayCard( content: content )
				),
			)
		),
	});

	testWidgets('Test the DisplayCard constructor', (tester) async {
		await tester.pumpWidget(myApp);

		final cardFinder = find.byType(DisplayCard);
		expect(cardFinder, findsOneWidget);
	});

	testWidgets('All content items are displayed', (tester) async {
		await tester.pumpWidget(myApp);

		final cardFinder = find.byType(DisplayCard);

		final entryFinder = find.text("Entry");
		expect(entryFinder, findsNWidgets(3));
	});
}
