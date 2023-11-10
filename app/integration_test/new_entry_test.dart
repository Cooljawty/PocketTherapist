import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app/pages/new_entry.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;

void main() {
  tearDown(() async => await settings.reset());

  testWidgets('Test the elements of the new entry page', (WidgetTester tester) async {
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: false,
    });
    app.main();

		final navigator = NavigatorObserver();

    //traverse to tag settings
    await tester.pumpAndSettle();
    Finder startbutton = find.byKey(const Key("Start_Button"));
    await tester.tap(startbutton);
    await tester.pumpAndSettle();
		await tester.tap(find.byKey(Key("Navbar_Destination_Entries")));
		await tester.pumpAndSettle();
		await tester.tap(find.byKey(Key("New Entry")));
		await tester.pumpAndSettle();


		//You are now in the new entry page
		//What data will be in the entry
		final newTag = "Tag!";
		final newTitle = "Title!";
		final newEntry = "Journal!";

		//Create values for key
		final journalInput = find.byKey(const ValueKey("journalInput"));
		final titleInput = find.byKey(const ValueKey("titleInput"));

		final saveButton = find.byKey(const ValueKey("saveButton"));
		final planButton = find.byKey(const ValueKey("planButton"));
		final tagButton = find.byKey(const ValueKey("tagButton"));


		//Find the 3 inputs
		expect(titleInput, findsOneWidget);
		expect(journalInput, findsOneWidget);
		expect(tagButton, findsOneWidget);

		expect(find.text('Save'), findsOneWidget);
		expect(find.text('Tag'), findsOneWidget);
		expect(find.text('Plan'), findsOneWidget);


		// Test adding title to the title
		await tester.tap(titleInput);
		await tester.enterText(titleInput, newTitle);
		await tester.pump();
		var titleText = (titleInput.evaluate().single.widget as TextField).controller!.text;
		expect(titleText, equals(newTitle));

		// Test adding text to the journal entry
		await tester.tap(journalInput);
		await tester.enterText(journalInput, newEntry);
		await tester.pump();
		var journalText = (journalInput.evaluate().single.widget as TextField).controller!.text;
		expect(journalText, equals(newEntry));


		//TODO: Test plan
		await tester.tap(planButton);
		await tester.pump();


		//Testing tag creation
		await tester.tap(tagButton);
		await tester.pumpAndSettle();

		//Enter a new tag name
    final searchBar = find.byKey(const Key('Tag Search Bar'));
    expect(searchBar, findsOneWidget);
    await tester.enterText(searchBar, newTag);
    await tester.pumpAndSettle();

		//Create tag with given name
    final createTagButton = find.byKey(const Key('Create Tag'));
    expect(createTagButton, findsOneWidget);
    await tester.tap(createTagButton);
    await tester.pumpAndSettle();

		//Select new tag
    final tagSelector = find.byKey(Key('Select $newTag Button'));
    expect(tagSelector, findsOneWidget);
		await tester.tap(tagSelector);
		await tester.pump();

		//Apply tags and return to journal edit page
		final applyTagButton = find.byType(BackButton);
    expect(applyTagButton, findsOneWidget);
		await tester.tap(applyTagButton);
		await tester.pumpAndSettle();
		

		//Save new entry
		await tester.tap(saveButton);
		await tester.pump();

		//View new entry
		final card = find.byType(DisplayCard).first;
		expect(card, findsOneWidget);
		await tester.tap(card);
		await tester.pumpAndSettle();

		//Title, entry text, and applied tags should be displayed
		final title = find.text(newTitle);
		final text = find.text(newEntry);
		final tag = find.text("#$newTag");
		expect(title, findsOneWidget);
		expect(text, findsOneWidget);
		expect(tag, findsOneWidget);
		});
}
