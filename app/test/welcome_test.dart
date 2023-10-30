
import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/provider/settings.dart' as settings;

void main() {

  testWidgets("Password Account creation", (widgetTester) async {
    String password = "password123@";
    settings.setMockDefaults();
    await widgetTester.pumpWidget(const MaterialApp(home: WelcomePage()));
    await widgetTester.pumpAndSettle();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    expect(passwordField, findsOneWidget);

// Enter passwrodr ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pumpAndSettle();
    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

// Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle();
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(2)); // should be two alerts now, one on the other

// Find the 2nd input box ---------------------------------------------------------
    Finder confirmPasswordField = find.ancestor(
        of: find.text("Confirm Password"),
        matching: find.byType(TextFormField),
    );
    expect(confirmPasswordField, findsOneWidget);

// find the submit button on the 2nd alert -------------------------------------
    Finder submitVerificationButton = find.byKey(const Key('Verify_Password'));
    expect(submitVerificationButton, findsOneWidget);
// Submit mismatched password -------------------------------------------------
    await widgetTester.tap(submitVerificationButton);
    await widgetTester.pumpAndSettle();
// Nothing should have happened as a result of this----------------------------
// Submit exact password to the confirm password dialogue ----------------------
    await widgetTester.enterText(confirmPasswordField, password);
    await widgetTester.tap(submitVerificationButton);
    await widgetTester.pumpAndSettle();

  });

  testWidgets("No Password Account creation", (widgetTester) async {
    String password = "";
    settings.setMockValues();
    await widgetTester.pumpWidget(const MaterialApp(home: WelcomePage()));
    await widgetTester.pumpAndSettle();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    expect(passwordField, findsOneWidget);

// Enter passwrodr ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pumpAndSettle();
    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

// Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle();
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(2)); // should be two alerts now, one on the other

// Find the confirm button ---------------------------------------------------------
    Finder confirmNoPasswordButton = find.text("Yes");
    expect(confirmNoPasswordButton, findsOneWidget);
    await widgetTester.tap(confirmNoPasswordButton);
    await widgetTester.pumpAndSettle();
  });

}
