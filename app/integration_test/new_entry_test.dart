import 'package:app/helper/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;

void main() {

	// Initialize Values--------------------------------------------------
  //tearDown(() async => await settings.reset());
	// const newTag = "Tag!";

	// // Create values for journal input and title input
	late final Finder journalInput;
	late final Finder titleInput;

	// Create values for buttons
	late final Finder saveButton;
	late final Finder planButton;
	late final Finder tagButton;
	late final Finder emotionButton;
	//--------------------------------------------------------------------------


	// Navigate to the new entry page
	@override
	Future<void> setUp(WidgetTester tester) async {
		app.main();
		await tester.pumpAndSettle();

		// Set mock values in the settings
		settings.setMockValues({
			settings.configuredKey: true,
			settings.encryptionToggleKey: false,
		});

		await settings.load();

		// Enter the app
		Finder startButton = find.byKey(const Key("Start_Button"));
		await tester.tap(startButton);
		await tester.pumpAndSettle();

		// Find the nav bar button for entries page
		await tester.tap(find.byKey(const Key("Navbar_Destination_Entries")));
		await tester.pumpAndSettle();
		await tester.tap(find.byKey(const Key("New Entry")));
		await tester.pumpAndSettle();
	}

	// Save the entry and view it
	Future<void> navigateToEntry(WidgetTester tester) async {
		//Save new entry
		await tester.tap(saveButton);
		await tester.pumpAndSettle();

		// View new entry
		final card = find
				.byType(DisplayCard)
				.first;
		expect(card, findsOneWidget);
		await tester.tap(card);
		await tester.pumpAndSettle();
	}

	// Test if every widget is on new entry page
  testWidgets('New Entry Page is Displayed', (WidgetTester tester) async {
		await setUp(tester);
		await tester.pumpAndSettle();


		// Find the title to the new entry page
		expect(find.text("New Entry"), findsOneWidget);

		// initialize journal body and title for the rest of the tests
		journalInput = find.byKey(const ValueKey("journalInput"));
		titleInput = find.byKey(const ValueKey("titleInput"));

		// initialize save, plan, tag, and emotions buttons for the rest of the tests
		saveButton = find.byKey(const Key("saveButton"));
		planButton = find.byKey(const Key("planButton"));
		tagButton = find.byKey(const Key("tagButton"));
		emotionButton = find.byKey(const Key("emotionButton"));

		// Find the title and body for journal entry input fields
		expect(titleInput, findsOneWidget);
		expect(journalInput, findsOneWidget);

		// Find the plan, tag, save, and emotion buttons
		expect(saveButton, findsOneWidget);
		expect(planButton, findsOneWidget);
		expect(tagButton, findsOneWidget);
		expect(emotionButton, findsOneWidget);
	});

	// Test the input text fields
	testWidgets('The title and body field take in and display the correct input in entry page', (WidgetTester tester) async {
		await setUp(tester);

		const newTitle = "Title!";
		const newEntry = "Journal!";

		// Test adding title to the title field
		await tester.tap(titleInput);
		await tester.enterText(titleInput, newTitle);
		await tester.pump();
		var titleText = (titleInput
				.evaluate()
				.single
				.widget as TextField).controller!.text;

		// Check that the text in the title field is the same as the title text
		expect(titleText, equals(newTitle));

		// Test adding text to the journal entry field
		await tester.tap(journalInput);
		await tester.enterText(journalInput, newEntry);
		await tester.pump();
		var journalText = (journalInput
				.evaluate()
				.single
				.widget as TextField).controller!.text;

		// check that the text in the body field is the same as the body text
		expect(journalText, equals(newEntry));

		// Navigate to the new entry
		await navigateToEntry(tester);

		// Find the title on the entry page
		final title = find.text(newTitle);
		expect(title, findsOneWidget);

		// Find the body text on the entry page
		final text = find.text(newEntry);
		expect(text, findsOneWidget);
	});

	// TODO: Test plan
	testWidgets('Plan Button', (WidgetTester tester) async {
		await setUp(tester);
		await tester.tap(planButton);
		await tester.pump();
	});

	// Test if the tags interact properly with the alert dialog, chip display, and the created journal entry page
	testWidgets('Tag button pulls up tag menu and correct tags are displayed', (WidgetTester tester) async {

		// Initialize the tag list
		settings.tagList = [
			Tag(name: 'Calm', color: const Color(0xff90c6d0)),
			Tag(name: 'Centered', color: const Color(0xff794e5e)),
			Tag(name: 'Content', color: const Color(0xfff1903b)),
			Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
			Tag(name: 'Patient', color: const Color(0xff00c5cc)),
			Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
			Tag(name: 'Present', color: const Color(0xffff7070)),
			Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
			Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
			Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
		];

		await setUp(tester);

		// Tap the tag button to bring up the tag menu
		await tester.tap(tagButton);
		await tester.pumpAndSettle();

		// Find all the tags in the list and tap them
		for (int i = 0; i < settings.tagList.length; i++) {
			final tagKey = find.text(settings.tagList[i].name);
			expect(tagKey, findsOneWidget);
			await tester.tap(tagKey);
			await tester.pumpAndSettle();
		}

		// Tap on confirm button
		final confirmTagsButton = find.byKey(const Key('saveTagsButton'));
		await tester.tap(confirmTagsButton);
		await tester.pumpAndSettle();

		// Find the chip display
		final tagChips = find.byKey(const Key('TagChipsDisplay'));

		// See if all the selected tags are on the page
		for (int i = 0; i < settings.tagList.length; i++) {
			final tagName = find.text(settings.tagList[i].name);
			await tester.pumpAndSettle();

			// Confirm that the tag was seen
			expectLater(tagName, findsOneWidget);

			// Delete the first tag
			if(i == 0) {
				await tester.tap(tagName);
				await tester.pumpAndSettle();

				expect(tagName, findsNothing);
			}

			// Manually scroll through the list if the tag wasn't seen
			// Expect to find the tag after scroll
			await tester.drag(tagChips, const Offset(-50, 0));
			await tester.pumpAndSettle();
		}

		// Test that the menu can remove tags-------------------------------------
		await tester.tap(tagButton);
		await tester.pumpAndSettle();

		// tap the last tag in the tag menu
		final tagKey = find.text(settings.tagList.last.name).hitTestable();
		await tester.tap(tagKey);
		await tester.pumpAndSettle();

		// Tap on confirm button
		await tester.tap(confirmTagsButton);
		await tester.pumpAndSettle();

		// check to see if the tag is there
		final tagName = find.text(settings.tagList.last.name);
		await tester.pumpAndSettle();
		// It should not find it
		expectLater(tagName, findsNothing);

		// Manually scroll through the list to make sure it isn't there
		await tester.drag(tagChips, const Offset(-500, 0));
		await tester.pumpAndSettle();
		//------------------------------------------------------------------------

		// Navigate to the new entry
		await navigateToEntry(tester);

		// Find the tags on the entry page
		// i = 1 because we deleted the first tag
		// length - 1 because we removed the last tag
		for (int i = 1; i < settings.tagList.length -1 ; i++) {
			final tagName = find.text('#${settings.tagList[i].name} ');
			await tester.pumpAndSettle();

			// Confirm that the tag was seen
			expect(tagName, findsOneWidget);
		}

		// get the first tag that should have been deleted
		final deletedTag = find.text('#${settings.tagList[0].name} ');
		await tester.pumpAndSettle();

		// Should not find that tag
		expect(deletedTag, findsNothing);

		// get the last tag that should have been deleted
		final lastDeletedTag = find.text('#${settings.tagList.last.name} ');
		await tester.pumpAndSettle();

		// Should not find that tag
		expect(lastDeletedTag, findsNothing);
	});

	// Test if the emotions interact properly with the alert dialog, chip display, and the created journal entry page
	testWidgets('Emotion button pulls up emotion menu and correct emotions are displayed', (WidgetTester tester) async {

		// Initialize the emotion list
		settings.emotionList = {
			'Happy': const Color(0xfffddd68),
			'Trust': const Color(0xff308c7e),
			'Fear': const Color(0xff4c4e52),
			'Sad': const Color(0xff1f3551),
			'Disgust': const Color(0xff384e36),
			'Anger': const Color(0xffb51c1c),
			'Anticipation': const Color(0xffff8000),
		};

		await setUp(tester);

		// Tap the emotion button to bring up the emotion menu
		await tester.tap(emotionButton);
		await tester.pumpAndSettle();

		// Find all the emotions in the list and tap them
		for(int i = 0; i < settings.emotionList.length; i++){
			final emotionKey = find.text(settings.emotionList.entries.elementAt(i).key);
			expect(emotionKey, findsOneWidget);
			await tester.tap(emotionKey);
			await tester.pumpAndSettle();
		}

		// Tap on confirm button
		final confirmEmotionsButton = find.byKey(const Key('saveEmotionsButton'));
		await tester.tap(confirmEmotionsButton);
		await tester.pumpAndSettle();

		// Find the chip display
		final emotionChips = find.byKey(const Key('EmotionChipsDisplay'));

		// iterate through all of the emotions in the list and test the dial works
		for(int i = 0; i < settings.emotionList.length; i++){
			final emotionName = find.text(settings.emotionList.entries.elementAt(i).key);
			await tester.pumpAndSettle();

			// Confirm that the emotion was seen
			expectLater(emotionName, findsOneWidget);

			// Manually scroll through the list if the tag wasn't seen
			// Expect to find the tag after scroll
			await tester.drag(emotionChips, const Offset(-50, 0));
			await tester.pumpAndSettle();

			// Tap the emotion chip to pull up emotional dial
			await tester.tap(emotionName);
			await tester.pumpAndSettle();

			// find the emotionalDial
			final emotionalDial = find.byKey(const Key('EmotionalDial'));
			expect(emotionalDial, findsOneWidget);

			// Set a value on the emotional dial
			await tester.drag(find.byKey(const Key('EmotionalDial')), const Offset(100, 0));
			await tester.pumpAndSettle();
			expect(find.text('75'), findsOneWidget);

			// Only test the cancel button on the first emotion to save time on testing---------------
			if (i == 0) {
				// test the cancel button
				final cancelDial = find.byKey(const Key('cancelDial'));
				expect(cancelDial, findsOneWidget);
				await tester.tap(cancelDial);
				await tester.pumpAndSettle();

				// Tap on emotion and set value again
				await tester.tap(emotionName);
				await tester.pumpAndSettle();

				// check that the value wasn't saved, because cancel was selected
				expect(find.text('75'), findsNothing);

				// Set the value again
				await tester.drag(find.byKey(const Key('EmotionalDial')), const Offset(100, 0));
				await tester.pumpAndSettle();
			}
			//-----------------------------------------------------------------------------------------

			// test the save button
			final saveDial = find.byKey(const Key('saveDial'));
			expect(saveDial, findsOneWidget);
			await tester.tap(saveDial);
			await tester.pumpAndSettle();

			// test to see that the value saved only on the first widget to save time on test----------
			if(i == 0) {
				// Tap on emotion and see if the value is saved
				await tester.tap(emotionName);
				await tester.pumpAndSettle();

				// check that the value wasn't saved, because cancel was selected
				expect(find.text('75'), findsOneWidget);

				// save the intensity
				await tester.tap(saveDial);
				await tester.pumpAndSettle();
			}
			//----------------------------------------------------------------------------------------
		}

		// Test that the emotion is removed from the chip display when deselected from the menu-----
		// Tap the emotion button to bring up the emotion menu
		await tester.tap(emotionButton);
		await tester.pumpAndSettle();

		// Find the last emotion in the list
		final emotionKey = find.text(settings.emotionList.entries.last.key).hitTestable();
		await tester.tap(emotionKey);
		await tester.pumpAndSettle();

		// Tap on confirm button
		await tester.tap(confirmEmotionsButton);
		await tester.pumpAndSettle();

		// Check to see if the emotion is listed as a chip
		// Confirm that the emotion was not seen
		final emotionName = find.text(settings.emotionList.entries.last.key);
		await tester.pumpAndSettle();
		expectLater(emotionName, findsNothing);

		// Manually scroll through the list if the tag wasn't seen
		// Expect to find the tag after scroll
		await tester.drag(emotionChips, const Offset(-500, 0));
		await tester.pumpAndSettle();
		//------------------------------------------------------------------------------------------

		// Navigate to the new entry
		await navigateToEntry(tester);

		// search for all clicked emotions
		// length -1 because we removed the last emotion
		for(int i = 0; i < settings.emotionList.length - 1; i++){
			final emotionName = find.text('${settings.emotionList.entries.elementAt(i).key}: 75 ');
			await tester.pumpAndSettle();

			// Confirm that the emotion was seen on the entry with the intensity correct value
			expect(emotionName, findsOneWidget);
		}

		// Check to see that the last emotion is not there anymore
		final emotionNameEntry = find.text('${settings.emotionList.entries.last.key}: 75 ');
		await tester.pumpAndSettle();

		// Confirm that the emotion was seen on the entry with the intensity correct value
		expect(emotionNameEntry, findsNothing);
	});


		//Create tag with given name
    // final createTagButton = find.byKey(const Key('Create Tag'));
    // expect(createTagButton, findsOneWidget);
    // await tester.tap(createTagButton);
    // await tester.pumpAndSettle();

		//Enter a new tag name
    // final nameField = find.byKey(const Key('Tag Name Field'));
    // expect(nameField, findsOneWidget);
    // await tester.enterText(nameField, newTag);

		//Change tag's color from default grey to cyan
    // final colorSelector = find.byKey(const Key('Tag Color Field'));
    // expect(nameField, findsOneWidget);
    // await tester.tap(colorSelector);
		// await tester.pump();
		// await tester.pump(const Duration(seconds: 1)); //Flutter tests Dropdowns with a second pump
		// await tester.tap(find.text("Cyan").first);
		// await tester.pump();
		// await tester.pump(const Duration(seconds: 1));

		//Confirm new tag
    // final confirmTagButton = find.byKey(const Key('Save New Tag Button'));
    // expect(confirmTagButton, findsOneWidget);
		// await tester.tap(confirmTagButton);
    // await tester.pumpAndSettle();

		//Clear tag search bar
    // final searchBar = find.byKey(const Key('Tag Search Bar'));
    // expect(searchBar, findsOneWidget);
    // await tester.enterText(searchBar, "");
    // await tester.pumpAndSettle();

		//Select new tag
    // final tagSelector = find.byKey(const Key('Select $newTag Button'));
    // expect(tagSelector, findsOneWidget);
		// await tester.tap(tagSelector);
		// await tester.pump();

		//Apply tags and return to journal edit page
		// final applyTagButton = find.byType(BackButton);
    // expect(applyTagButton, findsOneWidget);
		// await tester.tap(applyTagButton);
		// await tester.pumpAndSettle();


		// Find the tag on the entry page
		// final tag = find.text("#$newTag");
		//expect(tag, findsOneWidget);

}
