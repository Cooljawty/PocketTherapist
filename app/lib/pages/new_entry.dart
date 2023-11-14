import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart';
import 'package:app/pages/settings_tag.dart';
import 'entry.dart';
// import 'package:app/helper/classes.dart';
import 'package:app/provider/settings.dart' as prov;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class NewEntryPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const NewEntryPage());
  }

  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final ValueNotifier<double> _progress = ValueNotifier(0);

  final _items = prov.tagList.map((tag) {
    return MultiSelectItem<Tag>(tag, tag.name);
  }).toList();
  List<Tag> _selectedTags = [];

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
          child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - 347,
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
                    minLines: 1,
                  ),
                ),

                MultiSelectChipDisplay(
                  items: _selectedTags.map((e) => MultiSelectItem(e, e.name)).toList(),
                  scroll: true,
                  onTap: (value) {
                    setState(() {
                      _selectedTags.remove(value);
                    });
                  },
                ),

                // Emotions
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
              ],
            )),
        CircularSeekBar(
          width: double.infinity,
          height: 175,
          progress: 0,
          maxProgress: 60,
          barWidth: 8,
          startAngle: 5,
          sweepAngle: 360,
          strokeCap: StrokeCap.butt,
          progressGradientColors: const [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple
          ],
          innerThumbRadius: 5,
          innerThumbStrokeWidth: 3,
          innerThumbColor: Colors.white,
          outerThumbRadius: 5,
          outerThumbStrokeWidth: 10,
          outerThumbColor: Colors.blueAccent,
          dashWidth: 20,
          dashGap: 10,
          animation: false,
          valueNotifier: _progress,
          child: Center(
            child: ValueListenableBuilder(
                valueListenable: _progress,
                builder: (_, double value, __) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${(value.round())}'),
                      ],
                    )),
          ),
        ),

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
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return MultiSelectDialog(
                                    items: _items,
                                    initialValue: _selectedTags,
                                    onConfirm: (values) {
                                      setState(() {
                                        _selectedTags = values;
                                      });
                                    },
                                  );
                                },
                              );
                            }),
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
      ])),
    );
  }

  getEntry() {
    return JournalEntry(
        title: titleController.text,
				entryText: journalController.text,
				date: DateTime.now(),
				tags: _tagList,
		);
  }

	//Update applied tags with the TagSettings Page
	_saveTagsToEntry(BuildContext context) async {
		final newTags = await Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => TagSettingsPage(selectedTags: _tagList)),
		);
		_tagList = newTags;
	}
}
