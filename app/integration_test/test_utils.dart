import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;

/// [startApp] starts the application in preparation for testing.
/// Should be called first and only once.
Future<void> startApp(WidgetTester tester) async {
  app.main();
  defaultSettings();
  do{
    await tester.pump();
  }while(!settings.isInitialized());
}

/// [startSkipFrontScreen] this starts the app by calling [startApp] and automatically
/// moves the test into the actual app, leaving the tester on the dashboard.
Future<void> startSkipFrontScreen(WidgetTester tester) async {
  await startApp(tester);
  // Enter the app
  Finder startButton = find.byKey(const Key("Start_Button"));
  await tap(tester, startButton);
}

/// [defaultSettings] configures the default settings for testing which includes
/// no encryption and the application already being configured so that the init
/// methods can be skipped during testing.
void defaultSettings() {
  settings.setMockValues({
    settings.configuredKey: true,
    settings.encryptionToggleKey: false,
  });
}

/// [pumpUntilFound] repeatedly calls [WidgetTester.pump()] until
/// the [found] parameter is found or it times out. (5 min)
/// use [settle] = true, to make it pumpAndSettle
Future<void> pumpUntilFound(WidgetTester tester, Finder found, [bool settle = false, Duration duration = Duration.zero]) async {
  if(settle){
    while(!found.hasFound){
      await tester.pumpAndSettle(duration);
    }
  } else {
    while(!found.hasFound){
      await tester.pump(duration);
    }
  }
}

/// [tap] can be used to tap on a widget with the Finder [found]
/// This automatically pumps the widget tree after tapping.
/// use [settle] = true, to make it pumpAndSettle
Future<void> tap(WidgetTester tester, Finder found, [bool settle = false, Duration duration = Duration.zero]) async {
  await tester.tap(found);
  if(settle) {
    await tester.pumpAndSettle(duration);
  } else {
    await tester.pump(duration);
  }
}