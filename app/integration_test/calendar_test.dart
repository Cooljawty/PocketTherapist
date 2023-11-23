import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter/material.dart';
import 'package:app/pages/calendar.dart';
import 'package:app/uiwidgets/cards.dart';

import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;

void main() {

  late Widget myApp;
  setUp(() => {
    myApp = const MaterialApp(
        home: CalendarPage(),
    )});

  testWidgets('Test calendar widget constructor', (WidgetTester tester) async {
		await tester.pumpWidget(myApp);

    final calendar = find.byKey(const Key("Calendar_Panel"));
		expect(calendar, findsOneWidget);

		final calendarGrid = find.byKey(const Key("Calendar_Grid"));
		expect(calendarGrid, findsOneWidget);

		//Ensuere the right number of days are on grid
		final today = DateTime.now();
		final firstOfTheMonth = DateTime(today.year, today.month, 1);
		final lastOfTheMonth = DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));

		final firstWeekPadding = firstOfTheMonth.weekday - 1;
		final lastWeekPadding = 7 - lastOfTheMonth.weekday;
		final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

		final calendarDays = find.byKey(const Key("Calendar_Day"));
		expect(calendarDays, findsNWidgets(totalDays));
  });

	testWidgets('Switching between time ranges', (WidgetTester tester) async {
		await tester.pumpWidget(myApp);
		
    final nextButton = find.byKey(const Key("Date_Next"));
		expect(nextButton, findsOneWidget);

    final previousButton = find.byKey(const Key("Date_Previous"));
		expect(previousButton, findsOneWidget);

		//Test forward
		var today = DateTime.now();
		while( today.isBefore(DateTime.now().add(Duration(days: 365)))){
			final firstOfTheMonth = DateTime(today.year, today.month, 1);
			final lastOfTheMonth = DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));

			final range = lastOfTheMonth.difference(DateTime(today.year, today.month, 1));
			today = today.add(range);

			//Ensuere the right number of days are on grid
			final firstWeekPadding = firstOfTheMonth.weekday - 1;
			final lastWeekPadding = 7 - lastOfTheMonth.weekday;
			final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

			await tester.tap(nextButton);
			await tester.pump();

			final calendarDays = find.byKey(const Key("Calendar_Day"));
			expect(calendarDays, findsNWidgets(totalDays));
		}

		//Test backward
		while( today.isAfter(DateTime.now().subtract(Duration(days: 2 * 365)))){
			final firstOfTheMonth = DateTime(today.year, today.month, 1);
			final lastOfTheMonth = DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));

			final range = lastOfTheMonth.difference(DateTime(today.year, today.month, 1));
			today = today.add(range);

			//Ensuere the right number of days are on grid
			final firstWeekPadding = firstOfTheMonth.weekday - 1;
			final lastWeekPadding = 7 - lastOfTheMonth.weekday;
			final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

			await tester.tap(previousButton);
			await tester.pump();

			final calendarDays = find.byKey(const Key("Calendar_Day"));
			expect(calendarDays, findsNWidgets(totalDays));
		}
	});

	Future<void> createNewEntry(WidgetTester tester) async {
		// Find the nav bar button for entries page
		await tester.tap(find.byKey(const Key("Navbar_Destination_Entries")));
		await tester.pumpAndSettle();
		await tester.tap(find.byKey(const Key("New Entry")));
		await tester.pumpAndSettle();

		const newTitle = "Title!";
		const newEntry = "Journal!";

		// Test adding title to the title field
		await tester.tap(find.byKey(const Key("titleInput")));
		await tester.enterText(find.byKey(const Key("titleInput")), newTitle);
		await tester.pump();

		// Test adding text to the journal entry field
		await tester.tap(find.byKey(const Key("journalInput")));
		await tester.enterText(find.byKey(const Key("journalInput")), newEntry);

		// Tap the emotion button to bring up the emotion menu
		await tester.tap(find.byKey(const Key("emotionButton")));
		await tester.pumpAndSettle();

		final emotionKey = find.text(settings.emotionList.entries.first.key);
		await tester.tap(emotionKey);
		await tester.pumpAndSettle();

		// Tap on confirm button
		final confirmEmotionsButton = find.byKey(const Key('saveEmotionsButton'));
		await tester.tap(confirmEmotionsButton);
		await tester.pumpAndSettle();

		// Find the chip display
		final emotionChips = find.byKey(const Key('EmotionChipsDisplay'));

		final emotionName = find.text(settings.emotionList.entries.first.key);
		await tester.pumpAndSettle();


		// Tap the emotion chip to pull up emotional dial
		await tester.tap(emotionName);
		await tester.pumpAndSettle();

		// find the emotionalDial
		final emotionalDial = find.byKey(const Key('EmotionalDial'));

		// Set a value on the emotional dial
		await tester.drag(find.byKey(const Key('EmotionalDial')), const Offset(100, 0));
		await tester.pumpAndSettle();

		// Save Emotion strength
		final saveDial = find.byKey(const Key('saveDial'));
		await tester.tap(saveDial);
		await tester.pumpAndSettle();

		//Save new entry
		await tester.tap(find.byKey(const Key("saveButton")));
		await tester.pumpAndSettle();
	}

  testWidgets('Calendar integration test', (WidgetTester tester) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

		app.main();
		await tester.pump();

		// Set mock values in the settings
		settings.setMockValues({
			settings.configuredKey: true,
			settings.encryptionToggleKey: false,
		});
		settings.emotionList = {
			'Happy': const Color(0xfffddd68),
		};

		// Enter the app
		Finder startButton = find.byKey(const Key("Start_Button"));
		await tester.tap(startButton);

		do{
			await tester.pump();
		}while(tester.widgetList(find.byKey(const Key("Navbar_Destination_Entries"))).isEmpty);

		await createNewEntry(tester);

		//Navigate to Calendar	
		await tester.tap(find.byKey(const Key("Navbar_Destination_Calendar")));
		await tester.pumpAndSettle();


		//Open todays entries(s)
		final calendarDays = find.byKey(const Key("Calendar_Day"));
		final firstWeekPadding = DateTime(DateTime.now().year, DateTime.now().month, 1).weekday - 1;
		final today = tester.widgetList(calendarDays).elementAt(firstWeekPadding + DateTime.now().day - 1);

		//Today should be colored according to the entry we just made
		final todayColor = ((today as Container).decoration as ShapeDecoration).color; 
		expect(todayColor, settings.emotionList["Happy"]);

		await tester.tap(find.byWidget(today));
		await tester.pumpAndSettle();

		// View new entry
		final card = find.byType(DisplayCard).first;
		expect(card, findsWidgets);
		await tester.tap(card);
		await tester.pumpAndSettle();
		expect(find.text("Title!"), findsOneWidget);
		expect(find.text("Journal!"), findsOneWidget);
  });

}
