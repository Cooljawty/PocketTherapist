import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:app/uiwidgets/buttons.dart';



void main() {

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
