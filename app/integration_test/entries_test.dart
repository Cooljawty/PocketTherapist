import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/entry.dart';
import 'package:app/helper/dates_and_times.dart';
import 'test_utils.dart';

void main() {
  group("Entry Creation Tests", () {
    // // Create values for journal input and title input
    late Finder titleInput;

    // Create values for buttons
    late Finder saveButton;
    late Finder planButton;
    late Finder tagButton;
    late Finder emotionButton;
    //--------------------------------------------------------------------------

    final List<JournalEntry> entrys = [
      JournalEntry(
          title: "Mood",
          entryText:
              'I was late for work because of heavy traffic, and as soon as I walked into the office, my manager confronted me about '
              'being late',
          date: DateTime(2022, 8, 18),
          emotions: [
            //Emotion(name: 'Anticipation', color: const Color(0xffff8000), strength: 60),
            Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 10),
            Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 60),
          ]),
      JournalEntry(
          title: "Complete a 10k race in under an hour by the end of the year.",
          entryText:
              'I want to complete a 10k race in under an hour by the end of the year because I want to challenge myself, push my limits,'
              ' and achieve something I’ve never done before.',
          date: DateTime(2022, 9, 14),
          emotions: [
            Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 100),
            Emotion(
                name: 'Anger', color: const Color(0xffb51c1c), strength: 100),
          ]),
      JournalEntry(
          title: "I am grateful for this moment of mindfulness",
          entryText:
              'Today, I took a few minutes to practice mindfulness during my lunch break. I closed my eyes and took a few deep breaths, '
              'feeling the air fill my lungs and then releasing it slowly.',
          date: DateTime(2022, 10, 21),
          tags: [
            Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
            Tag(name: 'Present', color: const Color(0xffff7070)),
            Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
            Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
            Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Centered', color: const Color(0xff794e5e)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
            Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
            Tag(name: 'Patient', color: const Color(0xff00c5cc)),
          ],
          emotions: [
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 100),
          ]),
      JournalEntry(
          title: "Extraordinary beauty of nature",
          entryText:
              'Today, I went for a hike at the nearby nature reserve and was struck by the abundance of wildflowers in bloom. As I walked '
              'along the trail, I noticed a field of vibrant blue, white, and red poppies swaying gently in the breeze.',
          date: DateTime(2023, 5, 17),
          tags: [
            Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
            Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
            Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Centered', color: const Color(0xff794e5e)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
            Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
          ],
          emotions: [
            Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 50),
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 100),
          ]),
      JournalEntry(
          title: "Flying Over the Ocean",
          entryText:
              'Last night, I dreamed I was flying over the ocean, soaring through the sky with my arms outstretched. The sun was shining '
              'bright and the sky was a brilliant shade of blue. ',
          date: DateTime(2022, 9, 12),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Centered', color: const Color(0xff794e5e)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
            Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
            Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
            Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
            Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
          ],
          emotions: [
            Emotion(
                name: 'Anticipation',
                color: const Color(0xffff8000),
                strength: 50),
            Emotion(
                name: 'Anger', color: const Color(0xffb51c1c), strength: 50),
          ]),
    ];
    // Navigate to the new entry page
    @override
    Future<void> setUp(WidgetTester tester) async {
      entries = entrys;
      emotionList = {
        'Happy': const Color(0xfffddd67),
        'Trust': const Color(0xff308c7d),
        'Fear': const Color(0xff4c4e51),
        'Sad': const Color(0xff1f3550),
        'Disgust': const Color(0xff384e35),
        'Anger': const Color(0xffb51c1b),
        'Anticipation': const Color(0xffff7fff),
        'Surprise': const Color(0xFFFF8200),
      };
      await skipToEntriesPage(tester, true);
      Finder newEntry = find.text("NewEntry");
      await tap(tester, newEntry, true);
      // initialize journal body and title for the rest of the tests
      titleInput = find.byKey(const Key("titleInput"));
      await pumpUntilFound(tester, titleInput);

      // initialize save, plan, tag, and emotions buttons for the rest of the tests
      saveButton = find.byKey(const Key("saveButton"));
      await pumpUntilFound(tester, saveButton);
      planButton = find.byKey(const Key("planButton"));
      await pumpUntilFound(tester, planButton);
      tagButton = find.byKey(const Key("tagButton"));
      await pumpUntilFound(tester, tagButton);
      emotionButton = find.byKey(const Key("emotionButton"));
      await pumpUntilFound(tester, emotionButton);
    }

    // Save the entry and view it, removed because scroll until visible doesnt work
    //with list view when there are multiple scrollable widgets.
    //Future<void> navigateToEntry(WidgetTester tester, String titleText) async {
    //  await tester.scrollUntilVisible(find.text(titleText), 1);
    //  // View new entry
    //  await tap(tester, find.byType(DisplayCard).first, true);
    //}

    // Test the input text fields
    testWidgets('title and body Creation', (WidgetTester tester) async {
      await setUp(tester);
      String newTitle = "Title!";

      // Test adding title to the title field
      await tap(tester, titleInput, true);
      await tester.enterText(titleInput, newTitle);
      await tester.pump();

      await tap(tester, saveButton, true);
      // Navigate to the new entry

      //await navigateToEntry(tester, newTitle);
      await tap(tester, find.text(newTitle), true);
      // Find the title on the entry page
      final title = find.text(newTitle);
      expect(title, findsNWidgets(2));

      saveButton.tryEvaluate();
      await tap(tester, saveButton, true); // save
      //await navigateToEntry(tester, newTitle);
      await tap(tester, find.text(newTitle), true);

      titleInput.tryEvaluate();
      await tap(tester, titleInput);
      await tester.enterText(titleInput, "newTitle?");

      saveButton.tryEvaluate();
      await tap(tester, saveButton, true); // save
      expect(find.text("newTitle?"),
          findsOneWidget); // Find the updated title on the screen
    });

    testWidgets('Plan Button', (WidgetTester tester) async {
      await setUp(tester);

      // Test cancelling date picker
      await tap(tester, planButton);
      await tap(tester, find.text("Cancel"));

      // Test picking date and time
      await tap(tester, planButton);
      await tap(tester, find.text("OK"));
      await tap(tester, find.text("OK"));

      await tap(tester, titleInput);
      await tester.enterText(titleInput, "Plan Test");

      await tap(tester, saveButton);
      await tap(tester, find.byKey(const Key("navEntries")), true);
      expect(find.text("Plan Test"), findsNothing);

      await tap(tester, find.byKey(const Key("navPlans")), true);
      expect(find.text("Plan Test"), findsOneWidget);

      await tap(
          tester,
          find.descendant(
              of: find.byType(DisplayCard),
              matching: find.byKey(const Key("PlanCompleteButton"))));
    });

    // Test if the tags interact properly with the alert dialog, chip display, and the created journal entry page
    testWidgets('Tag button pulls up tag menu and correct tags are displayed',
        (WidgetTester tester) async {
      await setUp(tester);
      // Tap the tag button to bring up the tag menu
      await tap(tester, tagButton, true);
      // Chip in the list
      var tagChip = find.byType(FilterChip).first;
      await tap(tester, tagChip); // Add
      await tap(tester, tagChip); // Remove
      await tap(tester, tagChip); // Add again
      // Tap on save button
      await tap(tester, find.byKey(const Key('saveTagsButton')), true);
      // chip on the page
      await tap(tester, find.byType(ActionChip).first);
    });

    // Test if the emotions interact properly with the alert dialog, chip display, and the created journal entry page
    testWidgets(
        'Emotion button pulls up emotion menu and correct emotions are displayed',
        (WidgetTester tester) async {
      await tester.pump();
      await setUp(tester);
      // Tap the tag button to bring up the tag menu
      await tap(tester, emotionButton, true);
      // Chip in the list
      var emoteChip = find.byType(FilterChip).first;
      await tap(tester, emoteChip); // Add
      await tap(tester, emoteChip); // Remove
      await tap(tester, emoteChip); // Add again
      // Tap on save button
      await tap(tester, find.byKey(const Key('saveEmotionsButton')), true);
      // chip on the page
      await tap(tester, find.byType(ActionChip).first);
      // find the emotionalDial
      final emotionalDial = find.byKey(const Key('EmotionalDial'));
      expect(emotionalDial, findsOneWidget);

      // Set a value on the emotional dial
      // Drag direction is weird because of the way the circle is divided
      await tester.drag(
          find.byKey(const Key('EmotionalDial')), const Offset(100, 10));
      await tester.pump();
      expect(find.text('45'), findsOneWidget);
      //test save and cancel buttons on emotional dial
      await tap(tester, find.byKey(const Key('saveDial')), true);
      // go back into emotional dial and expect value to be 45
      await tap(tester, find.byType(ActionChip).first);
      expect(find.text('45'), findsOneWidget);
      //test cancel button
      // Set value to different amount
      await tester.drag(
          find.byKey(const Key('EmotionalDial')), const Offset(50, 10));
      await tester.pump();
      await tap(tester, find.byKey(const Key('cancelDial')), true);
      await tap(tester, find.byType(ActionChip).first);
      expect(find.text('45'), findsOneWidget);
    });
  });

  group("Entry Display Tests", () {
// Navigate to the entries panel
    Future<void> setUp(WidgetTester tester) async {
      await skipToEntriesPage(tester);

			final thisYear = DateTime.now().year;
			final thisMonth = DateTime.now().month;
			final thisDay = DateTime.now().day;

			entries = [
				JournalEntry(
					title: "This is an entry", 
					entryText: 'This is the body\nEntry is made today', 
					date: DateTime.now()
				),
				//Test first day of week exception
				JournalEntry(
					title: "Monady entry", 
					entryText: 'Entry is at the start of the week', 
					date: DateTime(thisYear, thisMonth + 1, thisDay).subtract(Duration(days: DateTime.now().weekday - 1)),
				),
				//Test last day of week exception
				JournalEntry(
					title: "Sunday entry", 
					entryText: 'Entry is at end of week', 
					date: DateTime(thisYear, thisMonth - 1, thisDay).add(Duration(days: DateTime.now().weekday - 1)),
				),
				JournalEntry(
					title: "Entry on 1st", 
					entryText: 'Entry is at the start of the month', 
					date: DateTime(thisYear, thisMonth, 1),
				),
				JournalEntry(
					title: "Entry at end", 
					entryText: 'Entry is at end of the month, hopefully', 
					date: DateTime(thisYear, thisMonth+1, 1).subtract(const Duration(days: 1)),
				),
			];
    }

    @override
    Future<void> testForItems( WidgetTester tester, String filter) async {
      // Show all items in the entry database
      // entry.showAllItems = show;
      await setUp(tester);

      final dropdownKey = find.byKey(const ValueKey("SortByDateDropDown"));
      await pumpUntilFound(tester, dropdownKey);
      // find the drop down and tap it
      await tap(tester, dropdownKey, true);

      // find the Year option and tap it
      final weekDropDown = find.text(filter).last;
      await pumpUntilFound(tester, weekDropDown);
      await tap(tester, weekDropDown, true);

      // see if the dropdown is proper
      expect(find.text(filter), findsOneWidget);

			// See if date range is displayed
      DateTime firstOfYear = DateTime(DateTime.now().year, 1, 1);
      int weekNum = firstOfYear.getWeekNumber(firstOfYear, DateTime.now());
      DateTime upper = firstOfYear.add(Duration(days: (weekNum * 7)));
      DateTime lower = upper.subtract(const Duration(days: 6));

      // See if range label is displaying correctly
			var rangeText = switch(filter){
				"Week" => '${lower.formatDate().month} ${lower.formatDate().day} - ${upper.formatDate().month} ${upper.formatDate().day}, ${DateTime.now().year.toString()}',
				"Month" => "${DateTime.now().formatDate().month} ${DateTime.now().year.toString()}",
				_ => DateTime.now().year.toString(),
			};
			expect(find.text(rangeText), findsWidgets);

      // Check to see if every entry in the time span is there
      for (JournalEntry entry in entriesInDateRange(upper, lower, entries)) {

        final entryKey = find.byKey(Key(entry.id.toString()));
				final entryCard = find.descendant(
					of: find.byType(Dismissible),
					matching: entryKey,
				);
        await tester.pump();
        //is no longer usable with multiple scroll widgets on display
        //await tester.scrollUntilVisible(entryKey, 1);
        // Confirm that the entry was seen
        await expectLater(entryCard, findsOneWidget);
        await tester.pump();
      }
    }


    testWidgets(
        'See if all entries are correct and present - Week filter',
        (WidgetTester tester) async {
      await testForItems(tester, 'Week');
    });


    testWidgets(
        'See if all entries are correct and present - Month filter',
        (WidgetTester tester) async {
      await testForItems(tester, 'Month');
    });


    testWidgets(
        'See if all entries are correct and present - Year filter',
        (WidgetTester tester) async {
      await testForItems(tester, 'Year');
    });
  });

  group("Entry Deletion Tests", () {
    entries.add(JournalEntry(
        title: "This is an entry",
        entryText: 'This is the body',
        date: DateTime.now()));

    // Navigate to the entries panel
    // Navigate to the entries panel
    Future<void> setUp(WidgetTester tester) async {
      await skipToEntriesPage(tester);
    }

    testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
      await setUp(tester);

      final entry = entries[0].id.toString();
      Finder entryFinder = find.byKey(ValueKey(entry));
      await tester.pump();

      //confirm that entry exist
			final entryCard = find.descendant(
				of: entryFinder,
				matching: find.byType(DisplayCard),
			);
      expect(entryCard, findsOneWidget);

      //Drag the entry, then tap cancel button
      await tester.drag(entryCard, const Offset(-500, 0));
      await tester.pump();
      await tap(tester, find.text("CANCEL"), true);
      expect(find.descendant(
				of: entryFinder,
				matching: find.byType(DisplayCard),
			), findsOneWidget);

      //Drag the entry, then tap delete button
      await tester.drag(entryCard, const Offset(-500, 0));
      await tester.pump();
      await tap(tester, find.text("DELETE"), true);
      expect(find.descendant(
				of: entryFinder,
				matching: find.byType(DisplayCard),
			), findsNothing);
    });
  });

  group("Entry Filter Tests", () {
    // Create values for journal input and title input
    late Finder titleSearchBar;
    // New finders added for all three journal entries
    late Finder journal1;
    late Finder journal2;

    //--------------------------------------------------------------------------

    final List<JournalEntry> entrys = [
      JournalEntry(
          title: "Extraordinary Title",
          entryText:
              'Today, I went for a hike at the nearby nature reserve and was struck by the abundance of wildflowers in bloom. As I walked '
              'along the trail, I noticed a field of vibrant blue, white, and red poppies swaying gently in the breeze.',
          date: DateTime(DateTime.now().year, DateTime.now().month, 5),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Centered', color: const Color(0xff794e5e)),
          ],
          emotions: [
            Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 50),
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 100),
          ]),
      JournalEntry(
          title: "Flying Title",
          entryText:
              'Last night, I dreamed I was flying over the ocean, soaring through the sky with my arms outstretched. The sun was shining '
              'bright and the sky was a brilliant shade of blue. ',
          date: DateTime(DateTime.now().year, DateTime.now().month, 9),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
          ],
          emotions: [
            Emotion(
                name: 'Anticipation',
                color: const Color(0xffff8000),
                strength: 50),
            Emotion(
                name: 'Anger', color: const Color(0xffb51c1c), strength: 50),
          ]),
    ];

    // Navigate to the new entry page
    @override
    Future<void> setUp(WidgetTester tester) async {
      entries = entrys;
      emotionList = {
        'Happy': const Color(0xfffddd67),
        'Trust': const Color(0xff308c7d),
        'Fear': const Color(0xff4c4e51),
        'Sad': const Color(0xff1f3550),
        'Disgust': const Color(0xff384e35),
        'Anger': const Color(0xffb51c1b),
        'Anticipation': const Color(0xffff7fff),
        'Surprise': const Color(0xFFFF8200),
      };
      await skipToEntriesPage(tester, true);

      final dropdownKey = find.byKey(const ValueKey("SortByDateDropDown"));
      await pumpUntilFound(tester, dropdownKey);
      // find the drop down and tap it
      await tap(tester, dropdownKey, true);

      // find the Month option and tap it
      final weekDropDown = find.text("Month").last;
      await pumpUntilFound(tester, weekDropDown);
      await tap(tester, weekDropDown, true);
			await tester.pump();

			journal1 = find.byKey(Key(entrys[0].id.toString()));
      journal2 = find.byKey(Key(entrys[1].id.toString()));
      titleSearchBar = find.byKey(const Key('Filter_By_TextForm'));

			/*
      await tap(tester, journal1, true);

      // initialize save, plan, tag, and emotions buttons for the rest of the tests
      saveButton = find.byKey(const Key("saveButton"));
      await pumpUntilFound(tester, saveButton);
      planButton = find.byKey(const Key("planButton"));
      await pumpUntilFound(tester, planButton);
      tagButton = find.byKey(const Key("tagButton"));
      await pumpUntilFound(tester, tagButton);
      emotionButton = find.byKey(const Key("emotionButton"));
      await pumpUntilFound(tester, emotionButton);
      //save the journal entries
      await tap(tester, saveButton, true);
			*/
    }

    testWidgets('Journal entry title filter test', (WidgetTester tester) async {
      await setUp(tester);
      //initially we should see both journal entries
			journal1 = find.text(entries[0].title);
			journal2 = find.text(entries[1].title);

      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
      //filter for journal 2
      await tester.enterText(titleSearchBar, 'Flying');
      await tester.pump();
      expect(journal2, findsOneWidget);
      expect(journal1, findsNothing);
      //filter for journal 1
      await tester.enterText(titleSearchBar, 'Extraordinary');
      await tester.pump();
      expect(journal1, findsOneWidget);
      expect(journal2, findsNothing);
      //filter for both
      await tester.enterText(titleSearchBar, '');
      await tester.pump();
      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
    });

    testWidgets('Journal entry tag filter test', (WidgetTester tester) async {
      await setUp(tester);
      //initially we should see both journal entries
			journal1 = find.text(entries[0].title);
			journal2 = find.text(entries[1].title);

      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
      await tap(tester, find.text('Calm'), true);
      //both have calm tag so nothing changes
      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
      //filter to see journal 1 only
      await tap(tester, find.text('Centered'), true);
      expect(journal1, findsOneWidget);
      expect(journal2, findsNothing);
      //final filter sees no journal entries
      await tap(tester, find.text('Content'), true);
      expect(journal1, findsNothing);
      expect(journal2, findsNothing);
      //filter to see journal 2 only
      await tap(tester, find.text('Centered'), true);
      expect(journal1, findsNothing);
      expect(journal2, findsOneWidget);
      //unselect content tag to see both entries
      await tap(tester, find.text('Content'), true);
      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
    });
  });
  group("Entry Navbar Tests", () {
    // New finders added for all three journal entries
    late Finder journal1;
    late Finder journal2;

    // Create values for Navbar
    late Finder calendarButton;
    late Finder settingsButton;
    late Finder entriesButton;

    //--------------------------------------------------------------------------

    final List<JournalEntry> entrys = [
      JournalEntry(
          title: "Extraordinary beauty of nature",
          entryText:
              'Today, I went for a hike at the nearby nature reserve and was struck by the abundance of wildflowers in bloom. As I walked '
              'along the trail, I noticed a field of vibrant blue, white, and red poppies swaying gently in the breeze.',
          date: DateTime(2023, 5, 17),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Centered', color: const Color(0xff794e5e)),
          ],
          emotions: [
            Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 50),
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 100),
          ]),
      JournalEntry(
          title: "Flying Over the Ocean",
          entryText:
              'Last night, I dreamed I was flying over the ocean, soaring through the sky with my arms outstretched. The sun was shining '
              'bright and the sky was a brilliant shade of blue. ',
          date: DateTime(2022, 9, 12),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
          ],
          emotions: [
            Emotion(
                name: 'Anticipation',
                color: const Color(0xffff8000),
                strength: 50),
            Emotion(
                name: 'Anger', color: const Color(0xffb51c1c), strength: 50),
          ]),
    ];

    // Navigate to the new entry page
    @override
    Future<void> setUp(WidgetTester tester) async {
      entries = entrys;
      emotionList = {
        'Happy': const Color(0xfffddd67),
        'Trust': const Color(0xff308c7d),
        'Fear': const Color(0xff4c4e51),
        'Sad': const Color(0xff1f3550),
        'Disgust': const Color(0xff384e35),
        'Anger': const Color(0xffb51c1b),
        'Anticipation': const Color(0xffff7fff),
        'Surprise': const Color(0xFFFF8200),
      };
      await skipToEntriesPage(tester, true);
      //set finders for journal entries
			journal1 = find.descendant(
				of: find.byType(Dismissible),
				matching: find.byKey(Key(entries[0].id.toString())),
			);
			journal2 = find.descendant(
				of: find.byType(Dismissible),
				matching: find.byKey(Key(entries[1].id.toString())),
			);

      //set navbar finders
      calendarButton = find.byKey(const Key('navCalendar'));
      settingsButton = find.byKey(const Key('navSettings'));
      entriesButton = find.byKey(const Key('navEntries'));
    }

    testWidgets('nav bar test to get more coverage in entries',
        (WidgetTester tester) async {
      await setUp(tester);
      //initially we should see both journal entries on the entry page
      expect(journal1, findsOneWidget);
      expect(journal2, findsOneWidget);
      //navigate to calendar and back
      await tap(tester, calendarButton, true);
      await tap(tester, entriesButton, true);
      //navigate to settings
      await tap(tester, settingsButton, true);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}