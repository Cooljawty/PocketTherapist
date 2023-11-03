import 'package:flutter/material.dart';
import 'entry.dart';

class NewEntryPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const NewEntryPage());
  }

  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  // Add text controllers to retrieve text data
  final titleController = TextEditingController();
  final journalController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('New Entry'),

            // Title input textfield
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: titleController,
                key: const Key("titleInput"),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),

            // Journal input textfield
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: journalController,
                key: const Key("journalInput"),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Journal Entry',
                ),
                style: const TextStyle(color: Colors.black),
                maxLines: 8,
                minLines: 8,
              ),
            ),


            // Add emotion wheel

            //box SizedBox keeps the plan, tag, and save buttons on the bottom.
            const Expanded(child: SizedBox(height: 1)),
            //Row for overflow widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                                onPressed: () {
                                  Navigator.pop(context, getEntry());
                                }),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  getEntry() {
    return JournalEntry(
        title: titleController.text, entryText: journalController.text);
  }
}