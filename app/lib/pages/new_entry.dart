import 'package:flutter/material.dart';
import 'entry.dart';
import 'package:app/helper/classes.dart';
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

  final _items = prov.tagList.asMap().entries.map((tag) {
    int idx = tag.key;
    String val = tag.value;

    return MultiSelectItem<Tag>(Tag(id: idx, name: val), val);
  }).toList();

  final _emotionItems = prov.emotionList.asMap().entries.map((emotion) {
    int idx = emotion.key;
    String val = emotion.value;

    return MultiSelectItem<Emotion>(Emotion(id: idx, name: val), val);
  }).toList();
  
  List<Tag> _selectedTags = [];

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
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
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

            // Temporary Tags
            Padding(
              padding: const EdgeInsets.all(20),
              child: MultiSelectDialogField(
                items: _tagItems,
                title: const Text("Tags"),
                listType: MultiSelectListType.LIST,
                chipDisplay: MultiSelectChipDisplay(scroll: true),
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

            // Emotions
            Padding(
              padding: const EdgeInsets.all(20),
              child: MultiSelectDialogField(
                items: _emotionItems,
                title: const Text("Emotions"),
                listType: MultiSelectListType.LIST,
                chipDisplay: MultiSelectChipDisplay(
                  scroll: true,
                  onTap: (value) => _emotionalDial(context, value as Emotion),
                ),
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
                onConfirm: (results) {},
              ),
            ),
          ])),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          )),
    );
  }

  dynamic _emotionalDial(BuildContext context, Emotion emotion) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: CircularSeekBar(
              width: double.infinity,
              height: 175,
              progress: emotion.strength.toDouble(),
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
              dashWidth: 10,
              dashGap: 20,
              animation: false,
              valueNotifier: _progress,
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: _progress,
                    builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(() {
                              emotion.setStrength(value.round());
                              return '${value.round()}';
                            }()),
                            const Text('progress'),
                          ],
                        )),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }

  getEntry() {
    return JournalEntry(
        title: titleController.text,
        entryText: journalController.text,
        date: DateTime.now());
  }
}
