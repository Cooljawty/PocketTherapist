import 'package:integration_test/integration_test.dart';
import 'package:pocket_therapist/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_therapist/main.dart' as app;
import 'package:pocket_therapist/provider/settings.dart' as settings;

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

    expect(settings.getOtherSetting(settings.prefrencesPrefix), null);
    expect(settings.getOtherSetting(settings.fontScaleKey), 1.5);
  });

  testWidgets("Theme changes with different selections", (widgetTester) async {
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: false,
    });
    app.main();
    await widgetTester.pumpAndSettle();

    //Tap start
    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
  
    //Tap next
    startbutton = find.text("nextPageEntries");
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
    //Tap next
    startbutton = find.text("nextPagePlans");
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
    //Tap next
    startbutton = find.text("nextPageSettings");
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
    //On settings PAge
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

    await widgetTester.tap(find.text('Edit Emotion List'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Edit Tag List'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Enable/Disable Encryption'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text('Open Vault File'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(const Key('Select_New_Vault')));
    await widgetTester.pumpAndSettle();
    //Tap next
    startbutton = find.text("nextPageCalendar");
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
    //Tap next
    startbutton = find.text("nextPageDashboard");
    await widgetTester.tap(startbutton);
    await widgetTester.pumpAndSettle();
  });


}