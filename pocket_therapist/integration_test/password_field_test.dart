import 'package:pocket_therapist/uiwidgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Widget myApp;
  const Key testKey = Key("FindMePassword");

  setUp(() => {
    myApp = MaterialApp(
        home: Scaffold(
            body: SafeArea(
              child: ControlledTextField(
                key: testKey,
                hintText: "Password",
                validator: (textInField) => (textInField?.isEmpty ?? true) ? 'Field is required' : null,
              ),
            )))
  });

  testWidgets('Test Valid PasswordField', (tstr) async {
    await tstr.pumpWidget(myApp);
    await tstr.pumpAndSettle();

    expect(find.text("Password"), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    await tstr.enterText(find.byKey(testKey), "SuperSecretPassword");
    await tstr.pumpAndSettle();

    var finder = find.descendant(of: find.byKey(testKey),
        matching: find.byType(TextField));
    var field = tstr.firstWidget<TextField>(finder);

    expect(field.obscureText, true);
    finder = find.descendant(
        of: find.byKey(testKey),
        matching: find.byType(IconButton)
    );
    await tstr.tap(finder);
    await tstr.pumpAndSettle();

    // You must  refind the TextField, it gets redrawn
    finder = find.descendant(of: find.byKey(testKey),
        matching: find.byType(TextField));
    field = tstr.firstWidget<TextField>(finder);

    expect(field.obscureText, false);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('Testing Invalid PasswordField', (tstr) async {
    Key testKey = const Key("FindMePassword");
    await tstr.pumpWidget(myApp);
    await tstr.enterText(find.byKey(testKey), "SomeThingIncorrect");
    await tstr.pumpAndSettle();
    //Lets make it empty!
    await tstr.enterText(find.byKey(testKey), "");
    await tstr.pumpAndSettle();
    //Check if the current validator would have errored on the input text
    expect(tstr.widget<TextFormField>(find.byType(TextFormField)).validator!(''), isNotNull);
  });
}
