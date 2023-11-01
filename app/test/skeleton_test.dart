import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

import 'package:flutter/material.dart';
import 'package:app/uiwidgets/buttons.dart';



void main() {
  testNextPage(String textonPage, String label, WidgetTester tester)  async {
			//Page name is shown as page title and on the navigation bar
      Finder navigationButton = find.byKey(Key(label));
      await tester.tap(navigationButton);
      await tester.pumpAndSettle();

      expect(navigationButton, findsOneWidget);
      expect(find.text(textonPage), findsNWidgets(2));
  }

  testWidgets('Cycle through pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // found dashboard, find next thigns
		//Dashbord is shown as page title and on the navigation bar
    expect(find.text('Dashboard'), findsNWidgets(2)); 

    // On Dashboard finding things
    await testNextPage('Entries',   'Entries',   tester);
    await testNextPage('Settings',  'Settings',  tester);
    await testNextPage('Calendar',  'Calendar',  tester);
    await testNextPage('Dashboard', 'Dashboard', tester);

		// Ensure no duplicates
		expect(find.text('Dashboard'), findsNWidgets(2)); 
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
