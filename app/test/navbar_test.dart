import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/uiwidgets/navbar.dart';

void main() {
  late Widget myApp;

  setUp(() => {
		myApp = const MaterialApp(
			home: Scaffold(
				body: SafeArea(
				),
			),
		);
	}
  testWidgets('Test Navbar constructor', (tester) async {
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
  });
}
