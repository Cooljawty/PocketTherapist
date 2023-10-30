import 'package:app/pages/settings.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  ThemeData testBG = ThemeData.light();
  var myApp = ChangeNotifierProvider(
      create: (context) => ThemeSettings(),
      builder: (context, child) {
        final provider = Provider.of<ThemeSettings>(context);
        testBG = provider.theme;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.theme,
          home: const SettingsPage(),
        );
      }
  );

  testWidgets('We are at settings page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    // Verify that we have moved to the settings
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Select Dark theme from dropdown', (tester) async {
    // Pump the app till settings
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    // Find the drop down
    final dropdown = find.byKey(const ValueKey('StyleDropDown'));

    // Tap the drop down
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    // Find the dark option
    final darkDropDown = find.text('Dark').last;

    // Select the drop down and expect to be replaced with dark
    await tester.tap(darkDropDown);
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);

    // Test if the Theme is dark
    expect(ThemeSettings.darkTheme, testBG);
  });

  testWidgets('Select Light theme from dropdown', (tester) async {
    // Pump the app till settings
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    // Find the drop down
    final dropdown = find.byKey(const ValueKey('StyleDropDown'));

    // Tap the drop down
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    // Find the dark option
    final darkDropDown = find.text('Dark').last;

    // Select the drop down
    await tester.tap(darkDropDown);
    await tester.pumpAndSettle();

    // Tap the drop down again
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    // Find the light option
    final lightDropDown = find.text('Light').first;

    // Select the drop down and expect to be replaced with light
    await tester.tap(lightDropDown);
    await tester.pumpAndSettle();

    // Find the light option
    expect(find.text('Light'), findsOneWidget);

    // Test if the Theme is dark
    expect(ThemeSettings.lightTheme, testBG);
  });
/*
  testWidgets('Tap the edit emotions list', (tester) async {
    // Pump the app till settings
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    final button = find.widgetWithText(ElevatedButton, "Edit Emotion List");

    await tester.tap(button);
    await tester.pumpAndSettle();


  });
  */

  testWidgets("Ensure each button is on page", (tester) async {
    // Pump the app till settings
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    expect(find.text("Edit Emotion List"), findsOneWidget);
    expect(find.text("Edit Tag List"), findsOneWidget);
    expect(find.text("Enable/Disable Encryption"), findsOneWidget);
    expect(find.text("Dir"), findsOneWidget);
    expect(find.text("Open Vault File"), findsOneWidget);
    expect(find.text("Manage Data"), findsOneWidget);
  });
}
