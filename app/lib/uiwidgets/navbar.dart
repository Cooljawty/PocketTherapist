import 'package:flutter/material.dart';

/// NavBar provieds a navigation bar at the bottom of the screen that contains links to diffrent pages.
/// Each link, or Destination, is defiend by the page that includes the NavBar.
class NavBar extends StatelessWidget{
	final List<Destination> destinations;

	const NavBar({Key? key, required this.destinations}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return NavigationBar(
			destinations: destinations.map((destination) => destination.toWidget()).toList(),
			onDestinationSelected: (int index) {
				Navigator.of(context).pushReplacement(destinations[index].destination);
			},
		);
	}

}

class Destination {
	final String label;
	final IconData icon;
	final Route<dynamic> destination;

	Destination({required this.label, required this.icon, required this.destination});
	
	NavigationDestination toWidget() {
		return NavigationDestination(
			key: Key(label),
			icon: Icon(icon),
			label: label,
		);
	}
}
