/// Plans page currently unused - delete later if no more need

import 'package:app/pages/entry.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/new_entry.dart';
import 'package:app/uiwidgets/navbar.dart';
import 'package:provider/provider.dart';
import '../uiwidgets/decorations.dart';

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
				selectedIndex: 3,
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
