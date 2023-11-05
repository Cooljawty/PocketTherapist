import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/entries.dart';

void main() {
  testWidgets('Test the save, plan, and tag buttons',
          (WidgetTester tester) async {
        //Create values for keys
        final newEntryButton = find.byKey(const ValueKey("New Entry"));

        //Target the Entries page
        await tester.pumpWidget(const MaterialApp(home: EntriesPage()));

        expect(newEntryButton, findsOneWidget);

        await tester.tap(newEntryButton);
        await tester.pumpAndSettle();

        final saveButton = find.byKey(const ValueKey("saveButton"));
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

      });
}
