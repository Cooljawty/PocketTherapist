import 'package:app/pages/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/entries.dart';

void main() {
  entries.add(JournalEntry(title: "This is an entry", entryText: 'This is the body', date: DateTime(2022, 2, 7)),);

  testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EntriesPage()));
    final entryKey = find.byKey(ValueKey(entries[0].getTitle()));

    await tester.pump();
    //confirm that entry exist
    expect(find.text(entries[0].getTitle()), findsOneWidget);
    //drag the entry
    await tester.drag(entryKey, const Offset(-500, 0));
    await tester.pumpAndSettle();
    //confirm that the entry was deleted.
    expect(find.text('Entry 0'), findsNothing);
  });
}
