import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:app/pages/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:app/uiwidgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';



void main() {
  testNextPage(String textonPage, String label, WidgetTester tester)  async {
			//Page name is shown as page title and on the navigation bar
      Finder navigationButton = find.byKey(Key(label));
      await tester.tap(navigationButton);
      await tester.pumpAndSettle();

      expect(navigationButton, findsOneWidget);
      expect(find.text(textonPage), findsNWidgets(2));
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
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key('Password_Field')), 'Password');
    
    //wait for field to be submitted before checking if we enter the dashboard
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    
    //check that dashboard is entered
    //Dashbord is shown as page title and on the navigation bar
    expect(find.text('Dashboard'), findsNWidgets(2)); 

    // On Dashboard finding things
    await testNextPage('Entries',   'Entries',   tester);
    await testNextPage('Calendar',  'Calendar',  tester);
    await testNextPage('Dashboard', 'Dashboard', tester);

    // Ensure no duplicates
		expect(find.text('Dashboard'), findsNWidgets(2)); 
  });

  testWidgets('Settings go to settings page', (WidgetTester tester) async {
		ThemeData testBG = ThemeData.light();
		var myApp = ChangeNotifierProvider(
				create: (context) => ThemeSettings(),
				builder: (context, child) {
					final provider = Provider.of<ThemeSettings>(context);
					testBG = provider.theme;
					return MaterialApp(
						debugShowCheckedModeBanner: false,
						themeMode: ThemeMode.system,
						theme: provider.theme,
						home: const DashboardPage(),
					);
				}
		);

    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    
    // Tap the settings button
		Finder navigationButton = find.byKey(Key('Settings'));
		await tester.tap(navigationButton);
		await tester.pumpAndSettle();

    // Verify that we have moved to the settings
    expect(find.text('Settings'), findsOneWidget);
  });
}
