import 'package:app/pages/plans.dart';
import 'package:app/pages/entry.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/settings.dart';
import 'package:app/provider/theme_settings.dart';
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
  //Generated list of strings
  final items = List<JournalEntry>.generate(7, (i) => JournalEntry(
		title: "Entry $i",
		entryText: "This is the ${i}th entry",
    date: DateTime.now().add(Duration(days: i)),
	));



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Text('Entries'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PlansPage.route());
              },
              child: const Text('nextPagePlans')),
          //holds the list of entries
          Expanded(
              child: ListView.builder(
							itemCount: items.length,
							itemBuilder: (context, index) {
                // Sort the Journal entries by most recent date
              final sortedItems = items..sort((item1,item2) => item2.getDate().compareTo(item1.getDate()));
              final item = sortedItems[index];

              return Dismissible(

                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(item.getTitle()),
                //prevents right swipes
                direction: DismissDirection.endToStart,

                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    items.removeAt(index);
                  });

                  // Then show a snackbar.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('${item.getTitle()} dismissed')));
                },
                // Show a red background as the item is swiped away.
                // background: Container(
								// 	color: Colors.red,
								// ),
                child: item.asDisplayCard(),
              );
            },
          )
              //ListViewBuilder(),
              ),
          //box SizedBox keeps the plan, tag, and save buttons on the bottom.
          //const Expanded(child: SizedBox(height: 1)), // Covers entries
          //Row for overflow widget
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Bar()],
          ),
          FloatingActionButton(
            //add key for testing
            key: const Key('Settings_Button'),
            onPressed: () {
              Navigator.push(
                // Go to settings page
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
            tooltip: 'Settings',
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .onBackground,
            foregroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            shape: const CircleBorder(eccentricity: 1.0),
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    ));
  }
}

class Bar extends StatelessWidget {
  const Bar({super.key});

  @override
  //Creates the OverflowBar for the plan, tag, and save buttons
  Widget build(BuildContext context) {
    return Container(
        color: getCurrentTheme().colorScheme.onBackground,
        child: Row(
          children: [
            OverflowBar(
              spacing: 50,
              overflowAlignment: OverflowBarAlignment.center,
              children: <Widget>[
                TextButton(
                    key: const Key("planButton"),
                    child: const Text('Plan'),
                    onPressed: () {}),
                TextButton(
                    key: const Key("tagButton"),
                    child: const Text('Tag'),
                    onPressed: () {}),
                TextButton(
                    key: const Key("saveButton"),
                    child: const Text('Save'),
                    onPressed: () {}),
              ],
            )
          ],
        ));
  }
}
