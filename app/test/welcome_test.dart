import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
