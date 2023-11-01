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
			body: SafeArea(
				child: Column(
					children: [
						const Text('Dashboard'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 0,
				destinations: [
					Destinations['dashboard']!,
					Destinations['entries']!,
					Destinations['calendar']!,
					Destinations['settings']!,
				],
			),
		);
  }
}

