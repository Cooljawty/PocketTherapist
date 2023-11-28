import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_utils.dart';

import 'package:flutter/material.dart';

import 'package:app/pages/calendar.dart';
import 'package:app/pages/entries.dart';
import 'package:app/uiwidgets/decorations.dart';

import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;
import 'package:app/provider/entry.dart';

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
		final lastOfTheMonth = DateTime(today.month < DateTime.december ? today.year : today.year+1, today.month < DateTime.december ? today.month + 1 : 1, 1).subtract(Duration(days: 1));

		final firstWeekPadding = firstOfTheMonth.weekday - 1;
		final lastWeekPadding = 7 - lastOfTheMonth.weekday;
		final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

		final calendarDays = find.byKey(const Key("Calendar_Day"));
		expect(calendarDays, findsNWidgets(totalDays));
  });

	testWidgets('Test forward date switching', (WidgetTester tester) async {
		await tester.pumpWidget(myApp);
		
    final nextButton = find.byKey(const Key("Date_Next"));
		expect(nextButton, findsOneWidget);

    //Test forward
		var date = DateTime(DateTime.now().year, DateTime.now().month, 1);
		while( date.isBefore(DateTime(DateTime.now().year + 4, DateTime.now().month, 1)) ){
			//Calculate date of next month
			if ( date.month < 12 ){
				date = DateTime( date.year, date.month + 1, 1);
			} else {
				date = DateTime( date.year + 1, 1, 1);
			}

			final firstOfTheMonth = DateTime(date.year, date.month, 1);
			final lastOfTheMonth = DateTime(date.month < DateTime.december ? date.year : date.year+1, date.month < DateTime.december ? date.month + 1 : 1, 1).subtract(Duration(days: 1));

			final firstWeekPadding = firstOfTheMonth.weekday - 1;
			final lastWeekPadding = 7 - lastOfTheMonth.weekday;
			final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

			//Go to next month and test amount of days are correct
			await tap(tester, nextButton);
			final calendarDays = find.byKey(const Key("Calendar_Day"));
			expect(calendarDays, findsNWidgets(totalDays));
		}
	});

	testWidgets('Test backwards date switching', (WidgetTester tester) async {
		await tester.pumpWidget(myApp);
		
    final previousButton = find.byKey(const Key("Date_Previous"));
		expect(previousButton, findsOneWidget);

    //Test backward
		var date = DateTime(DateTime.now().year, DateTime.now().month, 1);
		while( date.isAfter(DateTime(DateTime.now().year - 4, DateTime.now().month, 1)) ){
			//Calculate date of previous month
			final lastOfPreviousMonth = date.subtract(Duration(days: 1));
			date = DateTime(lastOfPreviousMonth.year, lastOfPreviousMonth.month, 1);

		final firstOfTheMonth = DateTime(date.year, date.month, 1);
		final lastOfTheMonth = DateTime(date.month < DateTime.december ? date.year : date.year+1, date.month < DateTime.december ? date.month + 1 : 1, 1).subtract(Duration(days: 1));

			final firstWeekPadding = firstOfTheMonth.weekday - 1;
			final lastWeekPadding = 7 - lastOfTheMonth.weekday;
			final totalDays = firstWeekPadding + (lastOfTheMonth.difference(firstOfTheMonth).inDays + 1) + lastWeekPadding;

			//Go to previous month and test amount of days are correct
			await tap(tester, previousButton);
			final calendarDays = find.byKey(const Key("Calendar_Day"));
			expect(calendarDays, findsNWidgets(totalDays));
		}
	});

  testWidgets('Calendar integration test', (WidgetTester tester) async {
		
		await startAppWithSettings(tester, {
			settings.configuredKey: true,
			settings.encryptionToggleKey: false,
		});

		final today = DateTime.now();
		emotionList = {
			'Happy': const Color(0xfffddd68),
		};
		entries = [
			JournalEntry(
				title: "Title!",
				entryText: "Journal!",
				date: today,
				emotions: [ 
					Emotion(
						name: "Happy", 
						color: const Color(0xfffddd68), 
						strength: 50
					),
				]
			),
		];
		await skipToCalendarPage(tester);

		//Open todays entries(s)
		final calendarDays = find.byKey(const Key("Calendar_Day"));
		await pumpUntilFound(tester, calendarDays);

		final firstOfTheMonth = DateTime(today.year, today.month, 1);
		final firstWeekPadding = firstOfTheMonth.weekday - 1;
		final todayItem = tester.widgetList(calendarDays).elementAt(firstWeekPadding + today.day - 1) as Container;

		//Today should be colored according to the entry we just made
		final todayColor = (todayItem.decoration as ShapeDecoration).color; 
		expect(todayColor, emotionList["Happy"]);

		await tap(tester, find.byWidget(todayItem));
		await pumpUntilFound(tester, find.byType(EntryPanelPage)); 

		// View new entry
		final card = find.byType(DisplayCard);
		expect(card, findsWidgets);
		await tap(tester, card);
		expect(find.text("Title!"), findsOneWidget);
		expect(find.text("Journal!"), findsOneWidget);
  });

}
