import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Widget myApp;

  setUp(() => {
        myApp = const MaterialApp(
            home: Scaffold(
          body: SafeArea(child: WelcomePage()),
        )),
        //add test case for the title page
      });
  testWidgets('Test if welcome page works', (tester) async {
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    expect(find.text("Pocket Therapist"), findsOneWidget);
  });

//create test for start button
  testWidgets('Test to see if start button is displayed when new',
      (widgetTester) async {
    //for shared preferences we must declare their initial values if they will be used
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': false
    };
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
  });
//create one more test for if the account is made then display password field
  testWidgets(
      'Test to see if password field is displayed when account is there',
      (widgetTester) async {
    //for shared preferences we must declare their initial values if they will be used
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true
    };
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Password_Field')), findsOneWidget);
  });
}
