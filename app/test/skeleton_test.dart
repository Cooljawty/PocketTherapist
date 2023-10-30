import 'package:app/main.dart';
import 'package:app/pages/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart' as settings;

void main() {
  testNextPage(String textonPage, String textOnButton, WidgetTester tester)  async {
      expect(find.text(textonPage), findsOneWidget);
      Finder nextPageButton = find.text(textOnButton);
      expect(nextPageButton, findsOneWidget);
      await tester.tap(nextPageButton);
      await tester.pumpAndSettle();
  }

  // testWidgets('Cycle through pages', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MaterialApp(
  //     home: DashboardPage(),
  //   ));
  //   // Configure with no password
  //   settings.setMockValues({
  //     settings.configuredKey: true,
  //     settings.encryptionToggleKey: false
  //   });
  //
  //   await tester.pumpAndSettle();
  //   // found dashboard, find next things
  //   Finder nextPageButton = find.text('nextPageEntries');
  //   expect(nextPageButton, findsOneWidget);
  //
  //   // On Dashboard finding things
  //    await testNextPage('Dashboard', 'nextPageEntries', tester);
  //    await testNextPage('Entries', 'nextPagePlans', tester);
  //    await testNextPage('Plans', 'nextPageSettings', tester);
  //    await testNextPage('Settings', 'nextPageCalendar', tester);
  //    await testNextPage('Calendar', 'nextPageDashboard', tester);
  //
  //      // Ensure no duplicates
  //     expect(find.text('Dashboard'), findsOneWidget);
  //     nextPageButton = find.text('nextPageEntries');
  //     expect(nextPageButton, findsOneWidget);
  // });

}
