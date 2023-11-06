import 'package:app/pages/plans.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/entry.dart';
import 'new_entry.dart';

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
  final items = List<JournalEntry>.generate(
      5,
      (i) => JournalEntry(
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
                background:
                    Container(color: Theme.of(context).colorScheme.primary),

                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Entry?"),
                        content: const Text(
                            "Are you sure you wish to delete this entry?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("DELETE")),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },

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
              child: const Text('New Entry')),
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
      items.add(result);
    });
  }
}
