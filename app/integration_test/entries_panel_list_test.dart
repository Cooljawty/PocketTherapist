import 'package:app/pages/entries.dart' as entry;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/entry.dart';
import 'package:app/provider/settings.dart' as settings;

import 'test_utils.dart';

void main() {

// Navigate to the entries panel
  @override
  Future<void> setUp(WidgetTester tester) async {
    await startApp(tester);

    // Set mock values in the settings
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: false,
    });

    // Enter the app
    Finder startButton = find.byKey(const Key("Start_Button"));
    await tester.tap(startButton);

    do {
      await tester.pump();
    } while (tester
        .widgetList(find.text("Entries"))
        .isEmpty);

    // Find the nav bar button for entries page
    await tester.tap(find.text("Entries"));
    await tester.pumpAndSettle();
  }

  entries.addAll([
    JournalEntry(title: "This is an entry", entryText: 'This is the body', date: DateTime(2022, 2, 7)),
    JournalEntry(title: "This is another entry", entryText: 'The next one wont have a body', date: DateTime(2022, 2, 6)),
    JournalEntry(title: "asdhfkjn", entryText: '', date: DateTime(2022, 2, 5)),
    JournalEntry(title: "Could be better", entryText: 'I am running out of ideas', date: DateTime(2021, 3, 17)),
    JournalEntry(title: "11sef sd63", entryText: ';)', date: DateTime(2021, 3, 5)),
    JournalEntry(title: "This is a test", entryText: 'asdfhdf', date: DateTime(2020, 1, 2)),
    JournalEntry(title: "This is the last entry", entryText: 'This is the last body', date: DateTime(2020, 7, 1)),
  ]);

  @override
  Future<void> testForItems(WidgetTester tester, String filter, bool show) async {
    // Show all items in the entry database
    entry.showAllItems = show;
    await setUp(tester);

    final dropdownKey = find.byKey(const ValueKey("SortByDateDropDown"));
    // find the drop down and tap it
    await tap(tester, dropdownKey, true);

    // find the Year option and tap it
    final weekDropDown = find.text(filter).last;
    await tap(tester, weekDropDown, true);

    // see if the dropdown is proper
    expect(find.text(filter), findsOneWidget);

    // Check to see if every entry is there
    for (int i = 0; i < entry.sortedItems.length; i++) {
      final entryKey = find.byKey(Key(entry.sortedItems[i].id.toString()));
      // await tester.pumpWidget(myApp);
      await tester.pumpAndSettle();

      // Confirm that the entry was seen
      expectLater(entryKey, findsOneWidget);

      // Manually scroll through the list if the entry wasn't seen
      // Expect to find the entry after scroll
      final gesture = await tester.startGesture(const Offset(100, 500));
      await gesture.moveBy(const Offset(0, -30));
      await tester.pump();
    }
  }

  testWidgets('See if all entries are correct and present - Week filter w/ show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Week', true);
  });

  testWidgets('See if all entries are correct and present - Week filter w/o show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Week', false);
  });

  testWidgets('See if all entries are correct and present - Month filter w/ show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Month', true);
  });

  testWidgets('See if all entries are correct and present - Month filter w/o show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Month', false);
  });

  testWidgets('See if all entries are correct and present - Year filter w/ show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Year', true);
  });

  testWidgets('See if all entries are correct and present - Year filter w/o show all entries', (WidgetTester tester) async {
    await testForItems(tester, 'Year', false);
  });
}
