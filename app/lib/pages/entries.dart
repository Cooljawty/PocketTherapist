import 'package:app/pages/plans.dart';
import 'package:app/pages/entry.dart';

import 'package:flutter/material.dart';

class EntriesPage extends StatefulWidget {

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => EntriesPage());
  }

	EntriesPage({super.key});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  //Generated list of strings
  final items = List<JournalEntry>.generate(5, (i) => JournalEntry(
		title: "Entry $i",
		entryText: "This is the ${i}th entry",
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
              final item = items[index];

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
                      .showSnackBar(SnackBar(content: Text('$item dismissed')));
                },
                // Show a red background as the item is swiped away.
                background: Container(
									color: Theme.of(context).colorScheme.primary
								),
                child: item.asDisplayCard(),
              );
            },
          )
              //ListViewBuilder(),
              ),
          //box SizedBox keeps the plan, tag, and save buttons on the bottom.
          const Expanded(child: SizedBox(height: 1)),
          //Row for overflow widget
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Bar()],
          )
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
        color: Theme.of(context).colorScheme.background,
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
