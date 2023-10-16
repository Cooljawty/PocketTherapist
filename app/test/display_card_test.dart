import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';

void main() {

	testWidgets('Test the DisplayCard constructor', (tester) async {
		var content = <String>["Entry"];

		await tester.pumpWidget(DisplayCard(content: content));

		final cardFinder = find.byType(DisplayCard);
		expect(cardFinder, findsOneWidget);
	});

	testWidgets('All content items are displayed', (tester) async {
		const entryCount = 3;
		var content = List<String>.filled(entryCount, "Entry");

		await tester.pumpWidget(DisplayCard(content: content));

		final cardFinder = find.byType(DisplayCard);

		final entryFinder = find.text("Entry");
		expect(entryFinder, findsNWidgets(entryCount));
	});
}
