import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_utils.dart';

void main() async {

  testWidgets("Password Account creation", (widgetTester) async {
    const String password = "password123@";

    await startApp(widgetTester);

    Finder startbutton = find.byKey(const Key("Start_Button"));
    await expectLater(startbutton, findsOneWidget);
    await tap(widgetTester, startbutton);

    Finder encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    await expectLater(passwordField, findsOneWidget); // Enter password ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pump();

    /// Submit the first password ( stores it ) // Tap enter button to create password ----------------------------------------------
    await tap(widgetTester, find.byKey(const Key('Create_Password')));

    await expectLater(find.byType(AlertDialog),
        findsNWidgets(2)); // should be two alerts now, one on the other// Find the 2nd input box ---------------------------------------------------------
    await expectLater(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ), findsOneWidget); // find the submit button on the 2nd alert -------------------------------------
    await expectLater(find.byKey(
        const Key('Verify_Password')), findsOneWidget); // Submit mismatched password -------------------------------------------------
    await tap(widgetTester, find.byKey(const Key('Verify_Password')));

    await widgetTester.showKeyboard(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ));
    await widgetTester.pump();

    await widgetTester.enterText(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ), password);
    await tap(widgetTester, find.byKey(const Key('Verify_Password')));
  });
}
