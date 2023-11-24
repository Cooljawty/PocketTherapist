import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {

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
			bottomNavigationBar: CustomNavigationBar(selectedIndex: 0)
		);
  }
}

