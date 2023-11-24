import 'package:app/uiwidgets/decorations.dart' as decorations;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {

  testWidgets("Ensuring new quote Appears when pressed", (widgetTester) async {
    //expected behavior, start button is present
    Widget myApp = MaterialApp(
        home: Scaffold(
            body: SafeArea(
              child: decorations.Quote(),
            )));
    await widgetTester.pumpWidget(myApp);
    await widgetTester.pump();

    Finder quoteButton = find.byKey(const Key("Quote"));
    String current = decorations.currentQuote;
    expect(find.text(current), findsOneWidget); // find the quote on screen

    await tap(widgetTester, quoteButton, false, const Duration(seconds: 2));

    String next = decorations.nextQuote;
    expect(find.text(current), findsNothing); // doesn't find old quote
    expect(find.text(next), findsOneWidget); // finds new quote
  });
  
}