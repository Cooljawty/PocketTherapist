import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  testWidgets("Ensuring new quote Appears when pressed", (widgetTester) async {
    //expected behavior, start button is present
    await widgetTester.pumpWidget(const RootApp());
    await widgetTester.pumpAndSettle();
    Finder quoteButton = find.text("New Quote");
    await widgetTester.tap(quoteButton);
    await widgetTester.pumpAndSettle();
  });
  
}