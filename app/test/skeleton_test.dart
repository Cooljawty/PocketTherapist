import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

import 'package:flutter/material.dart';
import 'package:app/uiwidgets/buttons.dart';



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
    // found dashboard, find next things
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

  testWidgets('Settings go to settings page', (WidgetTester tester) async {

      var myApp = const MaterialApp(
          home: Scaffold(
              body: SafeArea(
                child: SettingsButton(),
              )
          )
      );


    // Build our app and trigger a frame.
    await tester.pumpWidget(myApp);

    // Tap the settings button
    await tester.tap(find.byType(SettingsButton));
    await tester.pump();

    // Verify that we have moved to the settings
    expect(find.text('Settings'), findsOneWidget);
  });
}
