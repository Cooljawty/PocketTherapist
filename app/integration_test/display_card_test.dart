import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app/uiwidgets/cards.dart';
import 'package:app/pages/entry.dart';

void main() {
  final shortEntry = JournalEntry(
    title: "Short entry",
    entryText: "One line preview",
    creationDate: DateTime(2023, 11, 25),
  );

  final entry = JournalEntry(
    title: "Title of entry text",
    entryText: "Actual text of entry.\nMade long to test preview",
    creationDate: DateTime(2023, 11, 4),
  );

  late Widget myApp;
  setUp(() => {
        myApp = MaterialApp(
            home: Scaffold(
                body: SafeArea(
          child: Column(
            children: [
              shortEntry.asDisplayCard(),
              entry.asDisplayCard(),
            ],
          ),
        )))
      });

  testWidgets('Content of entry is displayed on DisplayCard', (tester) async {
    await tester.pumpWidget(myApp);

    final entryTitleFinder = find.text(entry.title);
    final entryPreviewFinder = find.text(entry.previewText);

    expect(entryTitleFinder, findsOneWidget);
    expect(entryPreviewFinder, findsOneWidget);
  });

  testWidgets('The asDisplayCard method displays an object in a DisplayCard',
      (tester) async {
    await tester.pumpWidget(myApp);

    final entryTitleFinder = find.text(entry.title);
    final entryPreviewFinder = find.text(entry.previewText);

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

    final title = find.text(shortEntry.title);
    final text = find.text(shortEntry.entryText);

    expect(title, findsOneWidget);
    expect(text, findsOneWidget);
  });
}
