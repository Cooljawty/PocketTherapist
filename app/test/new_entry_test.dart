import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/new_entry.dart';

void main() {
  testWidgets('Test the elements of the new entry page', (WidgetTester tester) async {
        //Create values for key
        final journalInput = find.byKey(const ValueKey("journalInput"));
        final titleInput = find.byKey(const ValueKey("titleInput"));

        final saveButton = find.byKey(const ValueKey("saveButton"));
        final planButton = find.byKey(const ValueKey("planButton"));
        final tagButton = find.byKey(const ValueKey("tagButton"));

        //Target the New Entry page
        await tester.pumpWidget(const MaterialApp(home: NewEntryPage()));

        //Find the 3 inputs
        expect(titleInput, findsOneWidget);
        expect(journalInput, findsOneWidget);
        expect(tagButton, findsOneWidget);

        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Tag'), findsOneWidget);
        expect(find.text('Plan'), findsOneWidget);

        // Test adding text to the title
        await tester.tap(titleInput);
        await tester.enterText(titleInput, "Title!");
        await tester.pump();
        var titleText = (titleInput.evaluate().single.widget as TextField)
            .controller!.text;
        expect(titleText, equals("Title!"));

        // Test adding text to the journal entry
        await tester.tap(journalInput);
        await tester.enterText(journalInput, "Journal!");
        await tester.pump();
        var journalText = (journalInput.evaluate().single.widget as TextField)
            .controller!.text;
        expect(journalText, equals("Journal!"));

        //Focus on the simulating tapping of the three buttons

        await tester.tap(planButton);
        await tester.pump();

        await tester.tap(tagButton);
        await tester.pump();

        await tester.tap(saveButton);
        await tester.pump();
      });
}