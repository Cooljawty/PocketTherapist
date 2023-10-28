import 'package:app/pages/plans.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/pages/entry.dart';

import 'package:flutter/material.dart';

class EntriesPage extends StatefulWidget {
	List<JournalEntry> entries = [ 
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
          child: ListView(
            children: [
              Container(
								child: const Text('Entries'),
							),
							ListView.builder(
								shrinkWrap: true,
								itemCount: widget.entries.length,
								itemBuilder: (context, index) => widget.entries[index].asDisplayCard(),
							),
              ElevatedButton(
								onPressed: () {
									Navigator.of(context).pushReplacement(PlansPage.route());
								},
								child: const Text('nextPagePlans'),
							),
            ],
          ),
        )
    );
  }
}
