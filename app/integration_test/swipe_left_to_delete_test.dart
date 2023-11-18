import 'package:app/pages/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/entries.dart';

void main() {
  entries.add(JournalEntry(title: "This is an entry", entryText: 'This is the body', date: DateTime(2022, 2, 7)));

  testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EntriesPage()));
    final entry = entries[0].getID().toString();
    final entryKey = Key(entry);
    Finder entryFinder = find.byKey(ValueKey(entry));
    await tester.pump();

    //confirm that entry exist
    expect(find.byKey(entryKey), findsOneWidget);

    //Drag the entry, then tap cancel button
    await tester.drag(entryFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("CANCEL"));
    await tester.pumpAndSettle();
    expect(find.byKey(entryKey), findsOneWidget);

    //Drag the entry, then tap delete button
    await tester.drag(entryFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("DELETE"));
    await tester.pumpAndSettle();
    expect(find.byKey(entryKey), findsNothing);
  });
}
