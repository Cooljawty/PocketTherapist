import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

import 'package:flutter/material.dart';
import 'package:app/uiwidgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  testNextPage(String textonPage, String textOnButton, WidgetTester tester)  async {
      expect(find.text(textonPage), findsOneWidget);
      Finder nextPageButton = find.text(textOnButton);
      expect(nextPageButton, findsOneWidget);
      await tester.tap(nextPageButton);
      await tester.pumpAndSettle();
  }

  // testWidgets('Test settings button', (widgetTester) async {
  //   await widgetTester.pumpWidget(const RootApp());
  //   await widgetTester.pumpAndSettle();
  //   Finder settingsButton = find.byType(FloatingActionButton);
  //   expect(settingsButton, findsOneWidget);
  //   await widgetTester.tap(settingsButton);
  //   await widgetTester.pumpAndSettle();
  //   expect(find.text("Settings"), findsOneWidget);
  // });

  testWidgets('Cycle through pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true,
      'Password': 'Password'
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    SharedPreferences temp = await SharedPreferences.getInstance();
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('Password_Field')), 'Password');
    //wait for field to be submitted before checking if we enter the dashboard
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    //check that dashboard is entered
    expect(find.text('Dashboard'), findsOneWidget);
    Finder nextPageButton = find.text('nextPageEntries');
    expect(nextPageButton, findsOneWidget);

    // On Dashboard finding things
     await testNextPage('Dashboard', 'nextPageEntries', tester);
     await testNextPage('Entries', 'nextPagePlans', tester);
     await testNextPage('Plans', 'nextPageCalendar', tester);
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
