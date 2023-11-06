import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Navagation between pages', (tester) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

		//Press start
    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await tester.tap(startbutton);
    await tester.pumpAndSettle();

		//Skip password creation
    Finder encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsOneWidget);

    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

    await tester.tap(enterPasswordButton);
    await tester.pumpAndSettle();
    encryptionAlert = find.byType(AlertDialog);
    expect(encryptionAlert, findsNWidgets(2)); 

    Finder confirmPasswordButton = find.text("Yes");
    expect(confirmPasswordButton, findsOneWidget);
    await tester.tap(confirmPasswordButton);
    await tester.pumpAndSettle();
		

		//Should be on the dashboard
		expect(find.text("Dashboard"), findsWidgets);
		
		//Navigate to each page
		for (var page in ["Dashboard", "Entries", "Calendar", "Plans", "Settings"]){
			await tester.tap(find.byKey(Key("Navbar_Destination_${page}")));
			await tester.pumpAndSettle();

			expect(find.text(page), findsWidgets);
		}

		//Back out of settings page
		await tester.pageBack();
		await tester.pumpAndSettle();
		expect(find.text("Calendar"), findsWidgets);

  });
}

