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

//case for when shared preference is null
  testWidgets('Test to see if shared preference is created',
      (widgetTester) async {
    //leave initial values empty for first time opening the app case
    final Map<String, Object> mockValues = <String, Object>{};
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    SharedPreferences temp = await SharedPreferences.getInstance();
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
    //now test on pressed event for button
    await widgetTester.tap(find.byKey(const Key('Start_Button')));
    expect(temp.getBool('DataInitialized'), true);
  });

//create test for new user with shared preference but no database ie shared pref is false
  testWidgets('Test to see if start button is displayed when new',
      (widgetTester) async {
    //for shared preferences we must declare their initial values if they will be used
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': false
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //wait some time for them to be set
    SharedPreferences temp = await SharedPreferences.getInstance();
    //expected behavior, start button is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
    //now test on pressed event for button
    await widgetTester.tap(find.byKey(const Key('Start_Button')));
    expect(temp.getBool('DataInitialized'), true);
  });
//test for user with database
  testWidgets(
      'Test to see if password field is displayed when account is there',
      (widgetTester) async {
    //for shared preferences we can declare their initial values if they will be used
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, password field is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Password_Field')), findsOneWidget);
  });
}
