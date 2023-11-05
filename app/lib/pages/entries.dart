import 'package:app/pages/plans.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/entry.dart';
import 'new_entry.dart';

class EntriesPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => EntriesPage());
  }

  final List<JournalEntry> entries = [
    JournalEntry(
        title: "Title",
        entryText: "Test entry\nthis text should not be in preview"
    ),
  ];

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
              ElevatedButton(
                  onPressed: () {
                    makeNewEntry();
                  },
                  key: const Key("New Entry"),
                  child: const Text('New Entry')
              ),
              //box SizedBox keeps the plan, tag, and save buttons on the bottom.
              const Expanded(child: SizedBox(height: 1)),


            ],
          ),
        ));
  }

  /// When the user presses New Entry, will bring user to the page for adding a
  /// journal entry. Upon completion, adds to the list of displayed entries.
  makeNewEntry() async {
    final result = await Navigator.push(context, NewEntryPage.route());
    setState(() {
      widget.entries.add(result);
    });
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
