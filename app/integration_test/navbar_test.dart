import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Navagation between pages', (tester) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    expect(startbutton, findsOneWidget);
    await tester.tap(startbutton);
    await tester.pumpAndSettle();

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
		
		expect(find.text("Dashboard"), findsNWidgets(2));
		
		//Navigate to each page
		for (var page in ["Dashboard", "Entries", "Calendar", "Settings"]){
			await tester.tap(find.byKey(Key("Navbar_Destination_${page}")));
			await tester.pumpAndSettle();

			expect(find.text(page), findsNWidgets(2));
		}

		//Back out of settings page
		await tester.pageBack();
		await tester.pumpAndSettle();
		expect(find.text("Calendar"), findsNWidgets(2));

  });
}

