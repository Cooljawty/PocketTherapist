import 'package:app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/provider/settings.dart' as settings;


void main() {

  tearDown(() async {
    await settings.reset();
  });


  testWidgets("Password Account creation", (widgetTester) async {
    app.main();
    const String password = "password123@";
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

// Enter password ---------------------------------------------------------------
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
    app.main();
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

  testWidgets("No Password But Then Password Account creation", (widgetTester) async {
    app.main();
    await widgetTester.pumpAndSettle();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);

// Enter passwrodr ---------------------------------------------------------------
    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

// Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle();
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(2)); // should be two alerts now, one on the other

// Find the confirm button ---------------------------------------------------------
    Finder confirmNoPasswordButton = find.text("No");
    expect(confirmNoPasswordButton, findsOneWidget);
    await widgetTester.tap(confirmNoPasswordButton);
    await widgetTester.pumpAndSettle();
  });

  testWidgets("Login to Account", (widgetTester) async {
    const String password = "password123@";
    const String badPassword = "password123";

    await settings.load();
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: true,
    });
    settings.setPassword(password);
    await settings.save();

    app.main();


    await widgetTester.pumpAndSettle();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);

    Finder passwordField = find.descendant(
        of: find.byKey(const Key("Login_Password_Field")),
        matching: find.byType(TextFormField)
    );
    expect(passwordField, findsOneWidget);

// Enter password ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, badPassword);
    await widgetTester.pumpAndSettle();

    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Submit_Password'));

    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle(const Duration(seconds: 19));

    Finder confirmIncorrectButton = find.byKey(const Key("Confirm_Incorrect_Password"));
    await widgetTester.tap(confirmIncorrectButton);
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(passwordField, password);
    await widgetTester.pumpAndSettle();

    Finder seePasswordButton = find.byType(IconButton);
    await widgetTester.tap(seePasswordButton);
    await  widgetTester.pumpAndSettle();
    await widgetTester.tap(seePasswordButton);
    await  widgetTester.pumpAndSettle();

    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle();

    //Successful login, on dashboard
    expect(find.text("Dashboard"), findsOneWidget);

    await widgetTester.tap(find.text("nextPageEntries"));
    await  widgetTester.pumpAndSettle();
    await widgetTester.tap(find.text("nextPagePlans"));
    await  widgetTester.pumpAndSettle();
    await widgetTester.tap(find.text("nextPageCalendar"));
    await  widgetTester.pumpAndSettle();
  });

}