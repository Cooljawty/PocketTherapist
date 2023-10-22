import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/uiwidgets/navbar.dart';

void main() {
  late Widget myApp;

  setUp(() => {
		myApp = const MaterialApp(
			home: TestPage(),
		)
	});

  testWidgets('Test Navbar constructor', (tester) async {
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

		expect(find.byType(NavBar), findsOneWidget);
  });

  testWidgets('Navagate between pages', (tester) async {
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

		var navbarItem = find.byKey(const Key("Page 2"));

		await tester.tap(navbarItem);
		await tester.pumpAndSettle();
		expect(find.text("Page 2"), findsOneWidget);
		
		navbarItem = find.byKey(const Key("Page"));

		await tester.tap(navbarItem);
		await tester.pumpAndSettle();
		expect(find.text("Page"), findsOneWidget);

  });
}

class TestPage extends StatefulWidget{
	static Route<dynamic> route(){
		return MaterialPageRoute(builder: (context) => const TestPage());
	}

	const TestPage({super.key});

	@override
	State<TestPage> createState() => _TestPageState();

}

class _TestPageState extends State<TestPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Test Page'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				destinations: [
					Destination(
						label: "Page",
						icon: Icons.turn_right,
						destination: TestPage.route(),
					),
					Destination(
						label: "Page 2",
						icon: Icons.turn_right,
						destination: TestPage2.route(),
					),
				],
			),
		);
	}
}

class TestPage2 extends StatefulWidget{
	static Route<dynamic> route(){
		return MaterialPageRoute(builder: (context) => const TestPage2());
	}

	const TestPage2({super.key});

	@override
	State<TestPage2> createState() => _TestPage2State();

}

class _TestPage2State extends State<TestPage2> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Test Page 2'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				destinations: [
					Destination(
						label: "Page",
						icon: Icons.turn_right,
						destination: TestPage.route(),
					),
					Destination(
						label: "Page 2",
						icon: Icons.turn_right,
						destination: TestPage2.route(),
					),
				],
			),
		);
	}
}
