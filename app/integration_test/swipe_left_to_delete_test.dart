import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/entries.dart';

void main() {
  testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
    final entryKey = find.byKey(const ValueKey("Entry 0"));
    await tester.pumpWidget(const MaterialApp(home: EntriesPage()));

    await tester.pump();
    //confirm that entry exist
    expect(find.text('Entry 0'), findsOneWidget);

    //Drag the entry, then tap cancel button
    await tester.drag(entryKey, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("CANCEL"));
    await tester.pumpAndSettle();
    expect(find.text('Entry 0'), findsOneWidget);

    //Drag the entry, then tap delete button
    await tester.drag(entryKey, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("DELETE"));
    await tester.pumpAndSettle();
    expect(find.text('Entry 0'), findsNothing);
  });
}
