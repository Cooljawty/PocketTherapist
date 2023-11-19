import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/calendar.dart';

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
}
