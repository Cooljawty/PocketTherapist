import 'package:app/pages/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Widget myApp;

  setUp(() => {
        //generate a material app to test the intro page
        myApp = const MaterialApp(
            home: Scaffold(
          body: SafeArea(
            child: IntroPage(),
          ),
        )),
      });
  testWidgets('Test if Intro page works', (tester) async {
    //first test will test when shared variable is false,
    //case is when user opens the app for the first time
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    //expect to find start button within the page, intro is the only page with
    //a start button
    expect(find.byKey(const Key("Start")), findsOneWidget);
    //check for if shared variable is false

    //hit button
    await tester.tap(find.byKey(const Key("Start")));
    await tester.pump();
    //hit skip tutorial on prompt
    await tester.tap(find.byKey(const Key("skip")));
    await tester.pumpAndSettle();
    //expect to find welcome page
    expect(find.text("Welcome Page"), findsOneWidget);
    //expect shared variable to be true
  });
}
