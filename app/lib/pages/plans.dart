import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const PlansPage());
  }
  const PlansPage({super.key });

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Plans'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 1,
				destinations: [
					destinations['dashboard']!,
					destinations['entries']!,
					destinations['calendar']!,
					destinations['plans']!,
					destinations['settings']!,
				],
			),
    );
  }
}
