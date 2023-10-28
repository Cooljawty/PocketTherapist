import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';

void main() {
	const entry = { 
		"title": "Title of entry", 
		"previewText": "Preview of entry",
		"entryText": "Actual text of entry"
	};

	final testObj = TestObject(
		title: "Test Object Title",
		body: "Body text of Test Object"
	);

	late Widget myApp;
  setUp(() => {
    myApp = MaterialApp(
			home: Scaffold(
				body: SafeArea(
					child: Column(
						children: [
							DisplayCard(
								title: entry['title'], 
								body: entry['previewText'],
								route: EntryPage.route(entry: entry)),
							testObj.displayCard(),
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

	testWidgets('The asDisplayCard method displays an object in a DisplayCard', (tester) async {
		await tester.pumpWidget(myApp);

		final entryTitleFinder = find.text(testObj.title);
		final entryPreviewFinder = find.text(testObj.body);

		expect(entryTitleFinder, findsOneWidget);
		expect(entryPreviewFinder, findsOneWidget);
	});

	testWidgets('Tapping on display card opens entry in new page', (tester) async {
		await tester.pumpWidget(myApp);

		final card = find.byType(DisplayCard);

		//Tap on display card and wait for new page to open
		await tester.tap(card);
		await tester.pumpAndSettle();

		final title = find.text("Title of entry");
		final text = find.text("Actual text of entry");

		expect(title, findsOneWidget);
		expect(text, findsOneWidget);
	});
}

class TestObject with DisplayOnCard{
	String title;
	String body;

	TestObject({this.title = "", required this.body}){
		card.title = title;
		card.content = body;
	}
}
