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

  late Widget myApp;
  setUp(() => {
        myApp = MaterialApp(
            home: Scaffold(
                body: SafeArea(
          child: Column(
            children: [
              entry.asDisplayCard(),
            ],
          ),
        )))
      });

  testWidgets('Test the DisplayCard constructor', (tester) async {
    await tester.pumpWidget(myApp);

    final cardFinder = find.byType(DisplayCard);
    expect(cardFinder, findsNWidgets(1));
  });

  testWidgets('Content of entry is displayed on DisplayCard', (tester) async {
    await tester.pumpWidget(myApp);

    final entryTitleFinder = find.text(entry.getTitle());
    final entryPreviewFinder = find.text(entry.getPreviewText());

    expect(entryTitleFinder, findsOneWidget);
    expect(entryPreviewFinder, findsOneWidget);
  });

  testWidgets('The asDisplayCard method displays an object in a DisplayCard',
      (tester) async {
    await tester.pumpWidget(myApp);

    final entryTitleFinder = find.text(entry.getTitle());
    final entryPreviewFinder = find.text(entry.getPreviewText());

    expect(entryTitleFinder, findsOneWidget);
    expect(entryPreviewFinder, findsOneWidget);
  });

  testWidgets('Tapping on display card opens entry in new page',
      (tester) async {
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
