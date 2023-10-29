import 'dart:io';

import 'package:app/main.dart' as app;
import 'package:app/pages/welcome.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

void main() {

  testWidgets("Password Account creation", (widgetTester) async {

    app.main();

    Finder startbutton = find.descendant(of: find.byKey(const Key('Start_Button')),
    matching: find.byType(TextButton));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();

    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    expect(passwordField, findsOneWidget);
    await widgetTester.enterText(passwordField, "password");
    await widgetTester.pumpAndSettle();
    Finder enterPasswordButton = find.byKey(const Key('Submit_Password'));
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pumpAndSettle();
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(2));
    Finder confirmPasswordAlert = find.ancestor(
        of: find.text("Confirm Password"),
        matching: find.byType(TextFormField),
    );
    expect(confirmPasswordAlert, findsOneWidget);
    Finder submitVerificationButton = find.byKey(const Key('Verify_Password'));
    await widgetTester.tap(submitVerificationButton);
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(3));
    Finder confirmPassMismatchButton = find.byKey(const Key('Confirm_Password_Mismatch'));
    await widgetTester.tap(confirmPassMismatchButton);
    passwordField = find.descendant(
        of: find.byKey(const Key('Confirm_Password_Field')),
        matching: find.byType(TextFormField)
    );
    await widgetTester.enterText(passwordField, "password");
    await widgetTester.tap(submitVerificationButton);
    expect(find.text("Dashboard"), findsOneWidget);
  });
}
