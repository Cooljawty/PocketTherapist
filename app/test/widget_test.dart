import 'package:app/pages/calendar.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:app/uiwidgets/settings_button.dart';


void main() {
  testNextPage(String textonPage, String textOnButton, WidgetTester tester)  async {
    expect(find.text(textonPage), findsOneWidget);
    Finder nextPageButton = find.text(textOnButton);
    expect(nextPageButton, findsOneWidget);
    await tester.tap(nextPageButton);
    await tester.pumpAndSettle();
  }

  testWidgets('Cycle through pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // found dashboard, find next thigns
    expect(find.text('Dashboard'), findsOneWidget);
    Finder nextPageButton = find.text('nextPageEntries');
    expect(nextPageButton, findsOneWidget);

    // On Dashboard finding things
    await testNextPage('Dashboard', 'nextPageEntries', tester);
    await testNextPage('Entries', 'nextPagePlans', tester);
    await testNextPage('Plans', 'nextPageSettings', tester);
    await testNextPage('Settings', 'nextPageCalendar', tester);
    await testNextPage('Calendar', 'nextPageDashboard', tester);

    // Ensure no duplicates
    expect(find.text('Dashboard'), findsOneWidget);
    nextPageButton = find.text('nextPageEntries');
    expect(nextPageButton, findsOneWidget);
  });

  testWidgets('Display Settings', (tester)  async {
    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: SettingsPage()));
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('nextPageCalendar'), findsOneWidget);
  });

  testWidgets('Display Calendar', (tester)  async {
    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: CalendarPage()));
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('nextPageDashboard'), findsOneWidget);
  });
  testWidgets('Display Settings', (tester)  async {
    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: SettingsPage()));
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('nextPageCalendar'), findsOneWidget);
  });

  testWidgets('Display Calendar', (tester)  async {
    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: CalendarPage()));
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('nextPageDashboard'), findsOneWidget);
  });

  testWidgets('Settings go to settings page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RootApp());

    // Tap the settings button
    await tester.tap(find.byType(SettingsButton));
    await tester.pump();

    // Verify that we have moved to the settings
    expect(find.text('Settings'), findsOneWidget);
  });
}
