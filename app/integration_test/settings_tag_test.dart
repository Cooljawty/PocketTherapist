import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart' as app;

void main() {
  String filter = 'test';

  //Initial test used to make sure that no create tag button is displayed
  testWidgets("Test to ensure tag list is displayed and functions properly",
      (widgetTester) async {
    //traverse to tag settings -------------------------------------------------
    app.main();
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key("Settings_Button")), findsOneWidget);
    await widgetTester.tap(find.byKey(const Key("Settings_Button")));
    await widgetTester.pumpAndSettle();
    expect(find.text('Edit Tag List'), findsOneWidget);
    await widgetTester.tap(find.text('Edit Tag List'));
    await widgetTester.pumpAndSettle();
    Finder target = find.byKey(const Key('Create Tag'));
    await widgetTester.pumpAndSettle();
    expect(target, findsNothing);

    //check a tag that we know doesnt exist ------------------------------------
    target = find.byKey(const Key('Tag Search Bar'));
    expect(target, findsOneWidget);
    await widgetTester.enterText(target, filter);
    await widgetTester.pumpAndSettle();
    target = find.byKey(const Key('Create Tag'));
    expect(target, findsOneWidget);

    //check tag creation and deletion ------------------------------------------
    target = find.byKey(Key('Delete $filter Button'));
    expect(target, findsNothing);

    target = find.byKey(const Key('Create Tag'));
    await widgetTester.tap(target);
    await widgetTester.pumpAndSettle();

		//Enter a new tag name
    target = find.byKey(const Key('Tag Name Field'));
    expect(target, findsOneWidget);
    await widgetTester.enterText(target, filter);

		//Confirm new tag
    target = find.byKey(const Key('Save New Tag Button'));
    expect(target, findsOneWidget);
		await widgetTester.tap(target);
    await widgetTester.pumpAndSettle();

		//Empty tag search bar
    target = find.byKey(const Key('Tag Search Bar'));
    await widgetTester.enterText(target, "");
    await widgetTester.pumpAndSettle();

    //try to delete tag
    await widgetTester.enterText(target, filter);
    await widgetTester.pumpAndSettle();
    target = find.byKey(Key('Delete $filter Button'));
    expect(target, findsOneWidget);
    await widgetTester.tap(target);
    await widgetTester.pumpAndSettle();

    //expect no delete button and create tag button again
    target = find.byKey(const Key('Tag Search Bar'));
    await widgetTester.enterText(target, filter);
    await widgetTester.pumpAndSettle();
    target = find.byKey(Key('Delete $filter Button'));
    expect(target, findsNothing);

		//Recreate tag
    target = find.byKey(const Key('Create Tag'));
    await widgetTester.tap(target);
    await widgetTester.pumpAndSettle();

		//Enter a new tag name
    target = find.byKey(const Key('Tag Name Field'));
    expect(target, findsOneWidget);
    await widgetTester.enterText(target, filter);

		//Confirm new tag
    target = find.byKey(const Key('Save New Tag Button'));
    expect(target, findsOneWidget);
		await widgetTester.tap(target);
    await widgetTester.pumpAndSettle();


    //check field submission with text and without -----------------------------
    target = find.byKey(const Key('Tag Search Bar'));
    expect(target, findsOneWidget);
    //try empty text field
    await widgetTester.enterText(target, '');
    await widgetTester.pumpAndSettle();
    target = find.byKey(const Key('Create Tag'));
    expect(target, findsNothing);
    //try with known good tag
    target = find.byKey(const Key('Tag Search Bar'));
    await widgetTester.enterText(target, filter);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();
    target = find.byKey(const Key('Create Tag'));
    expect(target, findsNothing);
  });
}
