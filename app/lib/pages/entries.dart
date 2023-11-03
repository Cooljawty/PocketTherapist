import 'package:app/pages/new_entry.dart';
import 'package:app/pages/plans.dart';
import 'package:app/pages/entry.dart';

import 'package:flutter/material.dart';

class EntriesPage extends StatefulWidget {
	final List<JournalEntry> entries = [ 
		JournalEntry(
			title: "Title", 
			entryText: "Test entry\nthis text should not be in preview"
		),
	];

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => EntriesPage());
  }

	EntriesPage({super.key});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
								padding: const EdgeInsets.all(2), 
								child: const Text('Entries'),
							),

              // List of entries
							ListView.builder(
								shrinkWrap: true,
								itemCount: widget.entries.length,
								itemBuilder: (context, index) => widget.entries[index].asDisplayCard(),
							),

              // Temporary navigation button
							ElevatedButton(
								onPressed: () {
									Navigator.of(context).pushReplacement(PlansPage.route());
								},
								child: const Text('nextPagePlans')
							),

              // Button to add a new Entry
              ElevatedButton(
                  onPressed: () {
                    makeNewEntry();
                  },
                  child: const Text('New Entry')
              ),
							//box SizedBox keeps the plan, tag, and save buttons on the bottom.
							const Expanded(child: SizedBox(height: 1)),
							//Row for overflow widget
							const Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [Bar()],
							),


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
