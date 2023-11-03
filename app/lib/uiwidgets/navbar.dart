import 'package:app/pages/dashboard.dart';
import 'package:app/pages/entries.dart';
import 'package:app/pages/calendar.dart';
import 'package:app/pages/settings.dart';

import 'package:flutter/material.dart';

/// NavBar provieds a navigation bar at the bottom of the screen that contains links to diffrent pages.
/// Each link, or Destination, is defiend by the page that includes the NavBar.
class NavBar extends StatelessWidget{
	final List<Destination> destinations;

	final int selectedIndex;

	const NavBar({Key? key, required this.destinations, this.selectedIndex = 0}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return NavigationBar(
			destinations: destinations.map((destination) => destination.toWidget()).toList(),
			labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
			selectedIndex: selectedIndex,
			onDestinationSelected: (int index) {
				if( index != selectedIndex ) {
					switch (destinations[index].destinationMethod) {
						case DestinationMethod.push:
							Navigator.of(context).push(destinations[index].destination);
						case DestinationMethod.pushReplacement:
							Navigator.of(context).pushReplacement(destinations[index].destination);
					}
				}
			},
		);
	}

}

///Defines a destinaton on the NavBar. Comes with an icon and a route to the page, and a label.
///The label also works as a key to the widget.
class Destination {
	final String label;
	final IconData icon;
	final Route<dynamic> destination;
	final DestinationMethod destinationMethod;

	Destination({
		required this.label, 
		required this.icon, 
		required this.destination, 
		this.destinationMethod = DestinationMethod.pushReplacement
	});
	
	NavigationDestination toWidget() {
		return NavigationDestination(
			key: Key(label),
			icon: Icon(icon),
			label: label,
		);
	}
}

enum DestinationMethod { push, pushReplacement }

///List of common destinations.
Map<String, Destination> destinations = {
	"dashboard": Destination( 
		label: "Dashboard", 
		icon: Icons.dashboard,       
		destination: DashboardPage.route(),
	),
	"entries": Destination( 
		label: "Entries", 
		icon: Icons.feed,            
		destination: EntriesPage.route(),
	),
	"calendar": Destination( 
		label: "Calendar", 
		icon: Icons.calendar_month, 
		destination: CalendarPage.route(),
	),
	"settings": Destination( 
		label: "Settings", 
		icon: Icons.settings,        
		destination: SettingsPage.route(),
		destinationMethod: DestinationMethod.push,
	),
};
