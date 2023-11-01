import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const DashboardPage());
  }

  const DashboardPage({super.key });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
		return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Dashboard'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 0,
				destinations: [
					destinations['dashboard']!,
					destinations['entries']!,
					destinations['calendar']!,
					destinations['settings']!,
				],
			),
		);
  }
}

