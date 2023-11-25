import 'package:integration_test/integration_test.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart' as app;
import 'package:app/provider/settings.dart' as settings;

void main() {


  tearDown(() async => await settings.reset());


  test("Settings works...", () async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    const String password = "password123@";
    await settings.load();
    settings.setMockValues({});
    settings.setFontScale(1.5);
    settings.setTheme(ThemeOption.dark);
    settings.setAccentColor(Colors.blueAccent);
    settings.setConfigured(true);
    settings.setPassword(password);
    settings.setEncryptionStatus(true);
    await settings.save();

    app.main();
    expect(settings.isInitialized(), true);
    expect(settings.getCurrentTheme().brightness, ThemeSettings.darkTheme.brightness);
    expect(settings.getFontScale(), 1.5);
    expect(settings.getAccentColor().value, Colors.blueAccent.value);
    expect(settings.isConfigured(), true);
    expect(settings.isEncryptionEnabled(), true);

    expect(settings.getOtherSetting(settings.preferencesPrefix), null);
    expect(settings.getOtherSetting(settings.fontScaleKey), 1.5);
  });

  testWidgets("Theme changes with different selections", (widgetTester) async {
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: false,
    });
    app.main();
    await widgetTester.pump();

    await widgetTester.tap(find.byKey(const Key("Settings_Button")));

    do{
      await widgetTester.pump();
    }while(widgetTester.widgetList(find.byKey(const ValueKey('StyleDropDown'))).isEmpty);

    // Find the drop down
    final dropdown = find.byKey(const ValueKey('StyleDropDown'));

    // Tap the drop down
    await widgetTester.tap(dropdown);
    await widgetTester.pumpAndSettle();

    // Find the dark option
    final darkDropDown = find.text('Dark').last;

    // Select the drop down and expect to be replaced with dark
    await widgetTester.tap(darkDropDown);
    await widgetTester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);

    //Find the provider & give me the state
    MaterialApp appState = widgetTester.widget(find.byType(MaterialApp));
    // Test if the Theme is dark
    expect(Brightness.dark, appState.theme?.brightness);
    expect(ThemeSettings.darkTheme.brightness, appState.theme?.brightness);
    // Tap the drop down again
    await widgetTester.tap(dropdown);
    await widgetTester.pumpAndSettle();

    // Find the light option
    final lightDropDown = find.text('Light').first;

    // Select the drop down and expect to be replaced with light
    await widgetTester.tap(lightDropDown);
    await widgetTester.pumpAndSettle();

    // Find the light option
    expect(find.text('Light'), findsOneWidget);

    appState = widgetTester.widget(find.byType(MaterialApp));
    // Test if the Theme is light
    expect(Brightness.light, appState.theme?.brightness);
    expect(ThemeSettings.lightTheme.brightness, appState.theme?.brightness);

    await widgetTester.tap(find.text('Edit Tag List'));
    await widgetTester.pumpAndSettle();

    await widgetTester.pageBack();
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Edit Emotion List'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(const Key('Enable/Disable Encryption')));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(const Key('Erase_Button')));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Open Vault File'));
    await widgetTester.pumpAndSettle();
  });
}
