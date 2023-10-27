import 'package:app/main.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/uiwidgets/buttons.dart';
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
    init();
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    expect(find.text("Pocket Therapist"), findsOneWidget);
  });
//case for when shared preference is null
  testWidgets('Test New user creating account with empty password',
          (widgetTester) async {
    init();
        //leave initial values empty for first time opening the app case
        final Map<String, Object> mockValues = <String, Object>{
          'DataInitializedTest': false
        };
        //set mock values
        SharedPreferences.setMockInitialValues(mockValues);
        //expected behavior, start button is present
        SharedPreferences temp = await SharedPreferences.getInstance();
        await widgetTester.pumpWidget(myApp);
        await widgetTester.pumpAndSettle();
        //expect to find a start button
        expect(find.byKey(const Key('Start_Button')), findsOneWidget);
        //now test DataInitialized to see if values are set
        expect(temp.getBool('DataInitialized'), false);
        //create a account without a password
        await widgetTester.tap(find.byKey(const Key('Start_Button')));
        await widgetTester.pumpAndSettle();
        //update to test to create empty password
        await widgetTester.tap(find.byKey(const Key('No_Password_Option')));
        await widgetTester.pumpAndSettle();
        //check that data is initialized and that dashboard page is entered
        expect(temp.getBool('DataInitialized'), true);
        //ensure password made is empty
        expect(temp.getString('Password'), "");
        expect(find.text('Dashboard'), findsOneWidget);
      });

//create test for user getting password loaded from local memory
//also will test reseting
  testWidgets('Test Account with password set up and reset of account',
          (widgetTester) async {
        //for shared preferences simulate a fresh account
        final Map<String, Object> mockValues = <String, Object>{
          'DataInitialized': true,
          'Password': "Password"
        };
        //set mock values
        SharedPreferences.setMockInitialValues(mockValues);
        //wait some time for them to be set
        SharedPreferences temp = await SharedPreferences.getInstance();
        //expected behavior, start button is present
        await widgetTester.pumpWidget(myApp);
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key('Password_Field')), findsOneWidget);
        //now we expect a password field
        //hit reset button and test if data Initialized remains false after update
        await widgetTester.tap(find.byKey(const Key('Reset_Button')));
        await widgetTester.pumpAndSettle();
        //now we would
        expect(temp.getBool('DataInitialized'), false);
      });
//test for user with no password chosen
  testWidgets(
      'Test to see if user with no password chosen can use start button',
          (widgetTester) async {
        //for shared preferences we can declare their initial values if they will be used
        final Map<String, Object> mockValues = <String, Object>{
          'DataInitialized': true,
          //update to include password shared preference to trigger password field
          'Password': ""
        };
        //set mock values
        SharedPreferences.setMockInitialValues(mockValues);
        //wait some time for them to be set
        SharedPreferences temp = await SharedPreferences.getInstance();
        //expected behavior, password field is present
        await widgetTester.pumpWidget(myApp);
        await widgetTester.pumpAndSettle();
        //should see a start button
        expect(find.byKey(const Key('Start_Button')), findsOneWidget);
        await widgetTester.tap(find.byKey(const Key('Start_Button')));
        await widgetTester.pumpAndSettle();
        //check that valuesa re as expected and dashboard page is entered
        expect(temp.getBool('DataInitialized'), true);
        //ensure password made is empty
        expect(temp.getString('Password'), "");
        expect(find.text('Dashboard'), findsOneWidget);
      });
  //test for new user who creates an empty password (same end state as user who choses no password)
  testWidgets('Test new user creating empty password', (widgetTester) async {

    //leave initial values empty for first time opening the app case
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': false
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    SharedPreferences temp = await SharedPreferences.getInstance();
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    //expect to find a start button
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
    //now test DataInitialized to see if values are set
    expect(temp.getBool('DataInitialized'), false);
    //create a account without a password
    await widgetTester.tap(find.byKey(const Key('Start_Button')));
    await widgetTester.pumpAndSettle();
    //update to test to create empty password
    await widgetTester.tap(find.byKey(const Key('No_Password_Option')));
    await widgetTester.pumpAndSettle();
    //check that data is initialized and that dashboard page is entered
    expect(temp.getBool('DataInitialized'), true);
    //ensure password made is empty
    expect(temp.getString('Password'), "");
    expect(find.text('Dashboard'), findsOneWidget);
  });

//create test for user getting password loaded from local memory
//also will test reseting
  testWidgets('Test Account with password set up and reset of account',
      (widgetTester) async {
    //for shared preferences simulate a fresh account
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true,
      'Password': "Password"
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //wait some time for them to be set
    SharedPreferences temp = await SharedPreferences.getInstance();
    //expected behavior, start button is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('Password_Field')), findsOneWidget);
    //now we expect a password field
    //hit reset button and test if data Initialized remains false after update
    await widgetTester.tap(find.byKey(const Key('Reset_Button')));
    await widgetTester.pumpAndSettle();
    //now we would
    expect(temp.getBool('DataInitialized'), false);
  });
//test for user with no password chosen
  testWidgets(
      'Test to see if user with no password chosen can use start button',
      (widgetTester) async {
    //for shared preferences we can declare their initial values if they will be used
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true,
      //update to include password shared preference to trigger password field
      'Password': ""
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //wait some time for them to be set
    SharedPreferences temp = await SharedPreferences.getInstance();
    //expected behavior, password field is present
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    //should see a start button
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
    await widgetTester.tap(find.byKey(const Key('Start_Button')));
    await widgetTester.pumpAndSettle();
    //check that valuesa re as expected and dashboard page is entered
    expect(temp.getBool('DataInitialized'), true);
    //ensure password made is empty
    expect(temp.getString('Password'), "");
    expect(find.text('Dashboard'), findsOneWidget);
  });
  //test for new user who creates an empty password (same end state as user who choses no password)
  testWidgets('Test new user creating empty password', (widgetTester) async {
    //leave initial values empty for first time opening the app case
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': false
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    SharedPreferences temp = await SharedPreferences.getInstance();
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    //expect to find a start button
    expect(find.byKey(const Key('Start_Button')), findsOneWidget);
    //create a account without a password
    await widgetTester.tap(find.byKey(const Key('Start_Button')));
    await widgetTester.pumpAndSettle();
    //update to test to create empty password
    await widgetTester.tap(find.byKey(const Key('Require_Password_Option')));
    await widgetTester.pumpAndSettle();
    //now the user has the option to add text to the field but we will leave it blank
    await widgetTester.tap(find.byKey(const Key('Save_Password')));
    await widgetTester.pumpAndSettle();
    //check that data is initialized
    expect(temp.getBool('DataInitialized'), true);
    //ensure password made is empty
    expect(temp.getString('Password'), "");
    //check that dashboard is entered
    expect(find.text('Dashboard'), findsOneWidget);
  });
  //final test case for inputting password to unlock welcome screen
  testWidgets('Test user logging in', (widgetTester) async {
    //leave initial values empty for first time opening the app case
    final Map<String, Object> mockValues = <String, Object>{
      'DataInitialized': true,
      'Password': 'Password'
    };
    //set mock values
    SharedPreferences.setMockInitialValues(mockValues);
    //expected behavior, start button is present
    SharedPreferences temp = await SharedPreferences.getInstance();
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pumpAndSettle();
    //expect to find a password field
    expect(find.byKey(const Key('Password_Field')), findsOneWidget);
    //try to log in to the field
    await widgetTester.tap(find.byKey(const Key('Password_Field')));
    await widgetTester.pumpAndSettle();
    //try wrong password first then try correct password
    await widgetTester.enterText(
        find.byKey(const Key('Password_Field')), 'WrongPassword');
    //wait for it to register
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();
    //expect the password field to still be there
    await widgetTester.tap(find.byKey(const Key('Password_Field')));
    //update to field to match password
    await widgetTester.enterText(
        find.byKey(const Key('Password_Field')), 'Password');
    //wait for field to be submitted before checking if we enter the dashboard
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();
    //check that data is still initialized
    expect(temp.getBool('DataInitialized'), true);
    //ensure password made is same as example
    expect(temp.getString('Password'), "Password");
    //check that dashboard is entered
    expect(find.text('Dashboard'), findsOneWidget);

  });
}