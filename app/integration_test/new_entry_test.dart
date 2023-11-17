import 'package:app/helper/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  //tearDown(() async => await settings.reset());
	// const newTag = "Tag!";
	const newTitle = "Title!";
	const newEntry = "Journal!";

	// Create values for key
	late final Finder journalInput;
	late final Finder titleInput;

	late final Finder saveButton;
	late final Finder planButton;
	late final Finder tagButton;
	late final Finder emotionButton;

	settings.setMockValues({
		settings.configuredKey: true,
		settings.encryptionToggleKey: false,
	});

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
	settings.emotionList = {
		'Happy': const Color(0xfffddd68),
		'Trust': const Color(0xff308c7e),
		'Fear': const Color(0xff4c4e52),
		'Sad': const Color(0xff1f3551),
		'Disgust': const Color(0xff384e36),
		'Anger': const Color(0xffb51c1c),
		'Anticipation': const Color(0xffff8000),
	};
	List<int> emotionStrengths = [10, 20, 30, 40, 50, 60, 70];


	// TODO: Test
	// this should be separate tests, not one big test??

  testWidgets('New Entry Page is Displayed', (WidgetTester tester) async {
		IntegrationTestWidgetsFlutterBinding.ensureInitialized();
		app.main();
		await tester.pumpAndSettle();
		await settings.load();

		// Enter the app
		Finder startButton = find.byKey(const Key("Start_Button"));
		await tester.tap(startButton);
		await tester.pumpAndSettle();

		// Find the nav bar button for entries page
		await tester.tap(find.byKey(const Key("Navbar_Destination_Entries")));
		await tester.pumpAndSettle();

		// Find the new entry button
		await tester.tap(find.byKey(const Key("New Entry")));
		await tester.pumpAndSettle();

		// Find the title to the new entry page
		expect(find.text("New Entry"), findsOneWidget);

		// Create values for key
		journalInput = find.byKey(const ValueKey("journalInput"));
		titleInput = find.byKey(const ValueKey("titleInput"));

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
	// });

	// testWidgets('The title and body field take in and display the correct input', (WidgetTester tester) async {
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
	// });

	// testWidgets('Plan Button', (WidgetTester tester) async {
		//TODO: Test plan
		await tester.tap(planButton);
		await tester.pump();
	// });

	// testWidgets('Tag button pulls up tag menu and correct tags are displayed', (WidgetTester tester) async {
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

			// Manually scroll through the list if the tag wasn't seen
			// Expect to find the tag after scroll
			await tester.drag(tagChips, const Offset(-20, 0));
			await tester.pump();
		}
	// });

	// testWidgets('Plan Button', (WidgetTester tester) async {
		//TODO: Test plan
		await tester.tap(planButton);
		await tester.pump();
		expect(find.byKey(const Key("planButton")), findsOneWidget);
	// });


	// testWidgets('Emotion button pulls up emotion menu and correct emotions are displayed', (WidgetTester tester) async {
		// Tap the tag button to bring up the emotion menu
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
		late final emotionalDial;

		for(int i = 0; i < settings.emotionList.length; i++){
			final emotionName = find.text(settings.emotionList.entries.elementAt(i).key);
			await tester.pumpAndSettle();

			// Confirm that the emotion was seen
			expectLater(emotionName, findsOneWidget);

			// Manually scroll through the list if the tag wasn't seen
			// Expect to find the tag after scroll
			await tester.drag(emotionChips, const Offset(-20, 0));
			await tester.pump();

			// Tap the emotion chip to pull up emotional dial
			// await tester.tap(emotionName);
			// await tester.pumpAndSettle();
			//
			// // find the emotionalDial
			// emotionalDial = find.byKey(const Key('EmotionalDial'));
			// expect(emotionalDial, findsOneWidget);

			// await tester.d
			// emotionStrengths
		}

	// });


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

	// testWidgets('Save the entry and see if everything is there', (WidgetTester tester) async {
		//Save new entry
		await tester.tap(saveButton);
		await tester.pump();

		// View new entry
		final card = find.byType(DisplayCard).first;
		expect(card, findsOneWidget);
		await tester.tap(card);
		await tester.pumpAndSettle();

		// Find the title on the entry page
		final title = find.text(newTitle);
		expect(title, findsOneWidget);

		// Find the body text on the entry page
		final text = find.text(newEntry);
		expect(text, findsOneWidget);

		// Find the tags on the entry page
		for (int i = 0; i < settings.tagList.length; i++) {
			final tagName = find.text('#${settings.tagList[i].name} ');
			await tester.pumpAndSettle();

			// Confirm that the tag was seen
			expect(tagName, findsOneWidget);
		}

		for(int i = 0; i < settings.emotionList.length; i++){
			final emotionName = find.text('${settings.emotionList.entries.elementAt(i).key}: 0 ');
			await tester.pumpAndSettle();

			// Confirm that the tag was seen
			expect(emotionName, findsOneWidget);
		}

		// Find the tag on the entry page
		// final tag = find.text("#$newTag");
		//expect(tag, findsOneWidget);
		});
}
