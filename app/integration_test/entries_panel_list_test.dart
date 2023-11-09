import 'package:app/pages/entries.dart' as entry;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/entry.dart';

void main() {

  late Widget myApp;
  setUp(() => {
    myApp = const MaterialApp(
        home: entry.EntriesPage(),
    )});

  entry.entries.addAll([
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
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    final dropdownKey = find.byKey(const ValueKey("SortByDateDropDown"));
    // find the drop down and tap it
    await tester.tap(dropdownKey);
    await tester.pumpAndSettle();

    // find the Year option and tap it
    final weekDropDown = find.text(filter).last;
    await tester.tap(weekDropDown);
    await tester.pumpAndSettle();

    // see if the dropdown is proper
    expect(find.text(filter), findsOneWidget);

    // Check to see if every entry is there
    for (int i = 0; i < entry.sortedItems.length; i++) {
      final entryKey = find.byKey(ValueKey(entry.sortedItems[i].getTitle()));
      await tester.pumpWidget(myApp);
      await tester.pumpAndSettle();

      // Confirm that the entry was seen
      expect(entryKey, findsOneWidget);
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
