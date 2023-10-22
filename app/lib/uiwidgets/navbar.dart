import 'package:flutter/material.dart';

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
			key: Key(this.label),
			icon: Icon( this.icon ),
			label: this.label,
		);
	}
}
