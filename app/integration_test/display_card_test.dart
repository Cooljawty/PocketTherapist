import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';
import 'package:app/pages/entry.dart';

void main() {
	final entry = JournalEntry( 
		title: "Title of entry text", 
		entryText: "Actual text of entry.\nMade long to test preview",
		date: DateTime(2023, 11, 4),
	);

	final testObj = TestObject(
		title: "Test Object Title",
		body: "Body text of Test Object",
		date: DateTime(2023, 11, 5),
	);

	late Widget myApp;
  setUp(() => {
    myApp = MaterialApp(
			home: Scaffold(
				body: SafeArea(
					child: Column(
						children: [
							DisplayCard(
								title: entry.getTitle(), 
								body: entry.getPreviewText(),
								date: entry.getDate(),
								page: () => EntryPage.route(entry: entry)
							),
							testObj.asDisplayCard(),
						],
					),
				)
			)
		)
	});

	testWidgets('Test the DisplayCard constructor', (tester) async {
		await tester.pumpWidget(myApp);

		final cardFinder = find.byType(DisplayCard);
		expect(cardFinder, findsNWidgets(2));
	});

	testWidgets('Content of entry is displayed on DisplayCard', (tester) async {
		await tester.pumpWidget(myApp);

		final entryTitleFinder = find.text(entry.getTitle());
		final entryPreviewFinder = find.text(entry.getPreviewText());

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

		final card = find.byType(DisplayCard).first;

		//Tap on display card and wait for new page to open
		await tester.tap(card);
		await tester.pumpAndSettle();

		final title = find.text(entry.getTitle());
		final text = find.text(entry.getEntryText());

		expect(title, findsOneWidget);
		expect(text, findsOneWidget);
	});
}

class TestObject with DisplayOnCard{
	String title;
	String body;
	DateTime date;

	TestObject({this.title = "", required this.body, required this.date}){
		card = (title: title, body: body, date: date);
	}
}
