import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart' as app;

void main() async {
  testWidgets("Password Account creation", (widgetTester) async {
    const String password = "password123@";
    app.main();
    await widgetTester.pumpAndSettle();
    Finder startbutton = find.byKey(const Key("Start_Button"));
    await expectLater(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle(); // First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    await expectLater(passwordField, findsOneWidget); // Enter passwrodr ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pumpAndSettle();
    /// Submit the first password ( stores it ) // Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(find.byKey(const Key('Create_Password')));
    await widgetTester.pumpAndSettle();
    await expectLater(find.byType(AlertDialog),
        findsNWidgets(2)); // should be two alerts now, one on the other// Find the 2nd input box ---------------------------------------------------------
    await expectLater(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ), findsOneWidget); // find the submit button on the 2nd alert -------------------------------------
    await expectLater(find.byKey(
        const Key('Verify_Password')), findsOneWidget); // Submit mismatched password -------------------------------------------------
    await widgetTester.tap(find.byKey(
        const Key('Verify_Password')));
    await widgetTester.pumpAndSettle(); // Nothing should have happened as a result of this----------------------------// Submit exact password to the confirm password dialogue ----------------------
    await widgetTester.showKeyboard(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ));
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(find.ancestor(
      of: find.text("Confirm Password"),
      matching: find.byType(TextFormField),
    ), password);
    await widgetTester.tap(find.byKey(
        const Key('Verify_Password')));
    await widgetTester.pumpAndSettle();
  });
}
