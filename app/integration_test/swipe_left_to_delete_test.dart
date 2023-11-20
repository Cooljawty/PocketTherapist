import 'package:app/pages/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/entries.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/main.dart' as app;

void main() {
  entries.add(JournalEntry(title: "This is an entry", entryText: 'This is the body', date: DateTime(2022, 2, 7)));

  // Navigate to the entries panel
  @override
  Future<void> setUp(WidgetTester tester) async {
    app.main();
    await tester.pump();

    // Set mock values in the settings
    settings.setMockValues({
      settings.configuredKey: true,
      settings.encryptionToggleKey: false,
    });

    // Enter the app
    Finder startButton = find.byKey(const Key("Start_Button"));
    await tester.tap(startButton);

    do {
      await tester.pump();
    } while (tester
        .widgetList(find.byKey(const Key("Navbar_Destination_Entries")))
        .isEmpty);

    // Find the nav bar button for entries page
    await tester.tap(find.byKey(const Key("Navbar_Destination_Entries")));
    await tester.pumpAndSettle();
  }

  testWidgets('Remove an entry from the list.', (WidgetTester tester) async {
    await setUp(tester);

    final entry = entries[0].getID().toString();
    final entryKey = Key(entry);
    Finder entryFinder = find.byKey(ValueKey(entry));
    await tester.pump();

    //confirm that entry exist
    expect(find.byKey(entryKey), findsOneWidget);

    //Drag the entry, then tap cancel button
    await tester.drag(entryFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("CANCEL"));
    await tester.pumpAndSettle();
    expect(find.byKey(entryKey), findsOneWidget);

    //Drag the entry, then tap delete button
    await tester.drag(entryFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("DELETE"));
    await tester.pumpAndSettle();
    expect(find.byKey(entryKey), findsNothing);
  });
}
