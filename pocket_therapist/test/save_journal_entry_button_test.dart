import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_therapist/pages/entries.dart';

void main() {
  testWidgets('Test the save, plan, and tag buttons',
          (WidgetTester tester) async {
        //Create values for keys
        final saveButton = find.byKey(const ValueKey("saveButton"));
        final planButton = find.byKey(const ValueKey("planButton"));
        final tagButton = find.byKey(const ValueKey("tagButton"));

        //Target the Entries page
        await tester.pumpWidget(const MaterialApp(home: EntriesPage()));

        //Focus on the simulating tapping of the three buttons
        await tester.tap(saveButton);
        await tester.pump();

        await tester.tap(planButton);
        await tester.pump();

        await tester.tap(tagButton);
        await tester.pump();


        //Find the save, tag, and plan buttons.
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Tag'), findsOneWidget);
        expect(find.text('Plan'), findsOneWidget);
      });
}