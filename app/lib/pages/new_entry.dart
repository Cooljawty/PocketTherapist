import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart';
import 'entry.dart';
import 'package:app/provider/settings.dart' as prov;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class NewEntryPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const NewEntryPage());
  }

  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

// Temporary tags - move to settings(?)
class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _items = prov.tagList.asMap().entries.map((tag) {
    int idx = tag.key;
    String val = tag.value;

    return MultiSelectItem<Tag>(Tag(id: idx, name: val), val);
  }).toList();
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

            // Temporary Tags
            Padding(
              padding: EdgeInsets.all(20),
              child: MultiSelectDialogField(
                items: _items,
                title: const Text("Tags"),
                listType: MultiSelectListType.LIST,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.tag,
                  color: Colors.blue,
                ),
                buttonText: Text(
                  "Tags",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                },
              ),
            ),

            // Temporary Tags
            Padding(
              padding: EdgeInsets.all(20),
              child: MultiSelectDialogField(
                items: _items,
                title: const Text("Emotions"),
                listType: MultiSelectListType.LIST,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.tag,
                  color: Colors.blue,
                ),
                buttonText: Text(
                  "Emotions",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                },
              ),
            ),

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
        title: titleController.text, entryText: journalController.text, date: DateTime.now());
  }
}