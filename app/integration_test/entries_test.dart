import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/entry.dart';
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
          title: "Location: Paris, France",
          entryText:
              'Today was my first day in Paris and it was absolutely magical. I woke up early and headed straight to the '
              'Eiffel Tower to catch the sunrise. The view from the top was breathtaking, with the sun just peeking over the horizon '
              'and casting a warm glow over the city.',
          date: DateTime(2022, 7, 12),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Present', color: const Color(0xffff7070)),
            Tag(name: 'Content', color: const Color(0xfff1903b)),
            Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
          ],
          emotions: [
            Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 90),
            Emotion(
                name: 'Anger', color: const Color(0xffb51c1c), strength: 70),
          ]),
      JournalEntry(
          title: "What are my core values and how do they impact my decisions?",
          entryText:
              'Today I’ve been considering my core values and how they impact the decisions I make in my life. I realize '
              'that my values are an essential part of who I am, and they play a significant role in shaping my thoughts, actions, '
              'and choices.',
          date: DateTime(2023, 1, 15),
          tags: [
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
            Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
          ],
          emotions: [
            Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 40),
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 70),
          ]),
      JournalEntry(
          title: "Today was a good day",
          entryText:
              'Today was a busy day at work. I had a lot of meetings and deadlines to meet, which kept me on my toes all day. '
              'I felt a little bit stressed at times, but overall, I was able to stay focused and get everything done that needed to '
              'be done.',
          date: DateTime(2023, 4, 27),
          tags: [
            Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
            Tag(name: 'Patient', color: const Color(0xff00c5cc)),
          ],
          emotions: [
            Emotion(
                name: 'Happy', color: const Color(0xfffddd68), strength: 80),
            Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 10),
            Emotion(
                name: 'Trust', color: const Color(0xff308c7e), strength: 10),
          ]),
      JournalEntry(
          title: '“If not now, when?”',
          entryText:
              'Today, I decided to experiment with some mixed media art in my art journal. I started'
              ' by collaging some old book pages onto the page, creating a textured background. Then, I used watercolors to paint over the top,'
              ' blending different colors and creating a dreamy, abstract effect.',
          date: DateTime(2022, 5, 12),
          tags: [
            Tag(name: 'Present', color: const Color(0xffff7070)),
            Tag(name: 'Calm', color: const Color(0xff90c6d0)),
          ]),
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

    // Save the entry and view it
    Future<void> navigateToEntry(WidgetTester tester, String titleText) async {
      await tester.scrollUntilVisible(find.text(titleText), 1);
      // View new entry
      await tap(tester, find.byType(DisplayCard).first, true);
    }

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
      await navigateToEntry(tester, newTitle);

      // Find the title on the entry page
      final title = find.text(newTitle);
      expect(title, findsNWidgets(2));

      saveButton.tryEvaluate();
      await tap(tester, saveButton, true); // save
      await navigateToEntry(tester, newTitle);

      titleInput.tryEvaluate(); // rerun the finder for the title
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
    });
  });

  group("Entry Display Tests", () {
// Navigate to the entries panel
    Future<void> setUp(WidgetTester tester) async {
      await skipToEntriesPage(tester);
    }

    entries.addAll([
      JournalEntry(
          title: "This is an entry",
          entryText: 'This is the body',
          date: DateTime(2022, 2, 7)),
      JournalEntry(
          title: "This is another entry",
          entryText: 'The next one wont have a body',
          date: DateTime(2022, 2, 6)),
      JournalEntry(
          title: "asdhfkjn", entryText: '', date: DateTime(2022, 2, 5)),
      JournalEntry(
          title: "Could be better",
          entryText: 'I am running out of ideas',
          date: DateTime(2021, 3, 17)),
      JournalEntry(
          title: "11sef sd63", entryText: ';)', date: DateTime(2021, 3, 5)),
      JournalEntry(
          title: "This is a test",
          entryText: 'asdfhdf',
          date: DateTime(2020, 1, 2)),
      JournalEntry(
          title: "This is the last entry",
          entryText: 'This is the last body',
          date: DateTime(2020, 7, 1)),
    ]);

    @override
    Future<void> testForItems(
        WidgetTester tester, String filter, bool show) async {
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

      // Check to see if every entry is there
      for (JournalEntry entry in entries) {
        final entryKey = find.byKey(Key(entry.id.toString()));
        await tester.pump();
        await tester.scrollUntilVisible(entryKey, 1);
        // Confirm that the entry was seen
        await expectLater(entryKey, findsOneWidget);
        await tester.pump();
      }
    }

    testWidgets(
        'See if all entries are correct and present - Week filter w/ show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Week', true);
    });

    testWidgets(
        'See if all entries are correct and present - Week filter w/o show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Week', false);
    });

    testWidgets(
        'See if all entries are correct and present - Month filter w/ show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Month', true);
    });

    testWidgets(
        'See if all entries are correct and present - Month filter w/o show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Month', false);
    });

    testWidgets(
        'See if all entries are correct and present - Year filter w/ show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Year', true);
    });

    testWidgets(
        'See if all entries are correct and present - Year filter w/o show all entries',
        (WidgetTester tester) async {
      await testForItems(tester, 'Year', false);
    });
  });

  group("Entry Deletion Tests", () {
    entries.add(JournalEntry(
        title: "This is an entry",
        entryText: 'This is the body',
        date: DateTime(2022, 2, 7)));

    // Navigate to the entries panel
    // Navigate to the entries panel
    Future<void> setUp(WidgetTester tester) async {
      await skipToEntriesPage(tester);
    }

    testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
      await setUp(tester);

      final entry = entries[0].id.toString();
      final entryKey = Key(entry);
      Finder entryFinder = find.byKey(ValueKey(entry));
      await tester.pump();

      //confirm that entry exist
      expect(find.byKey(entryKey), findsOneWidget);

      //Drag the entry, then tap cancel button
      await tester.drag(entryFinder, const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tap(tester, find.text("CANCEL"), true);
      expect(find.byKey(entryKey), findsOneWidget);

      //Drag the entry, then tap delete button
      await tester.drag(entryFinder, const Offset(-500, 0));
      await tester.pump();
      await tap(tester, find.text("DELETE"), true);
      expect(find.byKey(entryKey), findsNothing);
    });
  });
}
