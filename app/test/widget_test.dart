// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/pages/calendar.dart';
import 'package:app/pages/dashboard.dart';
import 'package:app/pages/entries.dart';
import 'package:app/pages/plans.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testNextPage(String textonPage, String textOnButton, WidgetTester tester)  async {
      expect(find.text(textonPage), findsOneWidget);
      Finder nextPageButton = find.text(textOnButton);
      expect(nextPageButton, findsOneWidget);
      await tester.tap(nextPageButton);
      await tester.pumpAndSettle();
  }

  testWidgets('Cycle through pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(RootApp());
    await tester.pump();
    // found dashboard, find next thigns
    expect(find.text('Dashboard'), findsOneWidget);
    Finder nextPageButton = find.text('nextPageEntries');
    expect(nextPageButton, findsOneWidget);

    // On Dashboard finding things
     await testNextPage('Dashboard', 'nextPageEntries', tester);
     await testNextPage('Entries', 'nextPagePlans', tester);
     await testNextPage('Plans', 'nextPageSettings', tester);
     await testNextPage('Settings', 'nextPageCalendar', tester);
     await testNextPage('Calendar', 'nextPageDashboard', tester);

  });
}
