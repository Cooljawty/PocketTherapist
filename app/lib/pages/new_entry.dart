import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart';
import 'package:app/pages/settings_tag.dart';
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

	//Save applied tags
	List<Tag> _tagList = [];

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

            // Title input text field
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: titleController,
                key: const Key("titleInput"),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),

            // Journal input text field
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: journalController,
                key: const Key("journalInput"),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Journal Entry',
                ),
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
                    color: getCurrentTheme().colorScheme.background,
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
																onPressed: () {
																	_saveTagsToEntry(context);
																},
														),
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
        title: titleController.text, entryText: journalController.text, date: DateTime.now());
  }

	_saveTagsToEntry(BuildContext context) async {
		final newTags = await Navigator.push(
			context, 
			MaterialPageRoute(builder: (context) => const TagSettingsPage()),
		);
		_tagList = newTags;
	}
}
