import 'package:app/uiwidgets/navbar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: const SafeArea(
				child: Column(
					children: [
						Text('Settings'),
					],
				),
			),
			bottomNavigationBar: NavBar(
				selectedIndex: 3,
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
//
// class SettingsManager extends ChangeNotifier {
//
//     // This will be changed to load and parse the settings.yml file with dart.yml
//     static Future<void> loadSettings([String fileName= "settings.yml"]) {
//       return Future.delayed (
//         const Duration(seconds: 5),
//           () => {"This": 0}
//       );
//     }
//
// }
