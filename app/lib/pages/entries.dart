import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';

class EntriesPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const EntriesPage());
  }

  const EntriesPage({super.key});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Entries'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 1,
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
