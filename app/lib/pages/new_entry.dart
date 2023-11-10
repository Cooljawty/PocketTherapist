import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart';
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
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  double _progress = 0;
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
                Expanded(
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
                         buttonIcon: const Icon(Icons.tag, color: Colors.blue,),
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
                    )
                ),
                CircularSeekBar(
                  width: double.infinity,
                  height: 250,
                  progress: _progress,
                  barWidth: 8,
                  startAngle: 45,
                  sweepAngle: 270,
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
                  dashWidth: 1,
                  dashGap: 2,
                  animation: false,
                  valueNotifier: _valueNotifier,
                  child: Center(
                    child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${value.round()}'),
                            Text('progress'),
                          ],
                        )
                    ),
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
                                    onPressed: () {}),
                                TextButton(
                                    key: const Key("saveButton"),
                                    child: const Text('Save'),
                                    onPressed: () {
                                      Navigator.pop(context, getEntry());
                                    }
                                ),
                              ],
                            )
                          ],
                        )
                    )
                  ],
                ),
              ]
          )
      ),
    );
  }

  getEntry() {
    return JournalEntry(
        title: titleController.text,
        entryText: journalController.text,
        date: DateTime.now());
  }
}
