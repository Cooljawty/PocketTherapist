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

  //create new test for text field and filter type
  testWidgets('Checks if all Search field filters by Title and Tag',
      (WidgetTester tester) async {
    String targetTitle = 'This is an Entry';
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    Finder searchBar = find.byKey(const Key('FilterByTextForm'));

    //first we expect there to be all entries displayed
    expect(entry.entries.length, entry.items.length);
    await tester.enterText(searchBar, targetTitle);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    Finder currentJournal = find.byKey(ValueKey(entry.items[0].getTitle()));

    //now after searching for one title we only expect the one entry
    expect(entry.items.length, 1);
    expect(currentJournal, findsOneWidget);

    //now test for tag search by switching the filter and checking
    Finder filterDropDown = find.byKey(const Key('FilterByDropDown'));
    await tester.tap(filterDropDown);
    await tester.pumpAndSettle();
    //Title is found twice due to it being the default set
    expect(find.text(entry.filterOptions[0]), findsNWidgets(2));
    expect(find.text(entry.filterOptions[1]), findsOneWidget);

    //select tag filter option
    await tester.tap(find.text(entry.filterOptions[1]));
    await tester.pumpAndSettle();
    //now we dont expect the list to hold any valid entries because no tags
    //would match the title.
    expect(entry.items.length, 0);
    expect(currentJournal, findsNothing);
  });
}
