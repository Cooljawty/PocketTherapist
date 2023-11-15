import 'package:flutter/material.dart';
import 'package:app/provider/theme_settings.dart';
import 'entry.dart';

import 'package:app/helper/classes.dart';
import 'package:app/provider/settings.dart' as settings;
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

  // current map of emotions to set in multiSelectItem
  final _emotionItems = settings.emotionList.asMap().entries.map((emotion) {
    String val = emotion.value;

    return MultiSelectItem<Emotion>(
        Emotion(name: val, color: Colors.white), val);
  }).toList();

  // List of selected tags to keep track of when making the chip list
  List<Tag> _selectedTags = [];
  List<Emotion> _selectedEmotions = [];

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
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            const Padding(padding: EdgeInsets.only(top: 70)),
            // Title of the page
            const Text('New Entry'),

            // Text field for the Journal Entry Title
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

            // Text input field for the Journal Entry Body
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

            // Chip display for the tags
            Padding(
              padding: const EdgeInsets.all(20),
              // Make the chips scrollable
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 5,
                    children: _selectedTags
                        .map((tag) => Chip(
                              label: Text(tag.name),
                              backgroundColor: tag.color,
                              onDeleted: () {
                                setState(() {
                                  _selectedTags.removeWhere(
                                      (element) => element.name == tag.name);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),

            /*
            * Emotion multi select button
            * Will create an Alert dialog field that will allow
            * users to select the emotions for the Journal Entry
            */
            Padding(
              padding: const EdgeInsets.all(20),
              child: MultiSelectDialogField(
                  items: _emotionItems,
                  title: const Text("Emotions"),
                  listType: MultiSelectListType.LIST,

                  // Style changes for Alert Dialog Selector confirm button
                  confirmText: Text(
                    key: const Key("ConfirmTag"),
                    "Confirm",
                    style: TextStyle(
                      color: settings.getCurrentTheme().colorScheme.primary,
                    ),
                  ),

                  // Style changes for Alert Dialog Selector cancel button
                  cancelText: Text(
                    key: const Key("CancelTag"),
                    "Cancel",
                    style: TextStyle(
                      color: settings.getCurrentTheme().colorScheme.primary,
                    ),
                  ),

                  // Style changes for Alert Dialog Selector list items when built
                  itemsTextStyle: TextStyle(
                      color: (settings.getCurrentTheme() ==
                              ThemeSettings.lightTheme)
                          ? Colors.black
                          : Colors.white),

                  // Style changes for Alert Dialog Selector list items when selected
                  selectedItemsTextStyle: TextStyle(
                      color: (settings.getCurrentTheme() ==
                              ThemeSettings.lightTheme)
                          ? Colors.black
                          : Colors.white),

                  // Style changes for Alert Dialog Selector list items when selected/notSelected
                  selectedColor: settings.getCurrentTheme().colorScheme.primary,
                  unselectedColor:
                      settings.getCurrentTheme().colorScheme.primary,

                  // Chip display of all the currently selected emotions
                  chipDisplay: MultiSelectChipDisplay(
                    items: _selectedEmotions
                        .map((e) => MultiSelectItem(e, e.name))
                        .toList(),
                    textStyle: TextStyle(
                        color: (settings.getCurrentTheme() ==
                                ThemeSettings.lightTheme)
                            ? settings.getCurrentTheme().colorScheme.secondary
                            : Colors.white),
                    chipColor: settings.getCurrentTheme().colorScheme.primary,

                    // Be able to scroll through all the selected emotions to avoid overflow
                    scroll: true,

                    // Make Alert Dialog pop-up when an emotion is selected to display emotional dial
                    onTap: (value) => _emotionalDial(context, value),
                  ),

                  // Decoration theme of the multi selector drop down
                  decoration: BoxDecoration(
                    color: settings
                        .getCurrentTheme()
                        .colorScheme
                        .primary
                        .withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: settings.getCurrentTheme().colorScheme.primary,
                      width: 2,
                    ),
                  ),

                  // Display Icon on the right side of the multi selector drop down
                  buttonIcon: Icon(
                    Icons.tag,
                    color: settings.getCurrentTheme().colorScheme.primary,
                  ),

                  // Text displayed on the drop down
                  buttonText: Text(
                    "Emotions",
                    style: TextStyle(
                      color: settings.getCurrentTheme().colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (values) {
                    setState(() {
                      _selectedEmotions = values;
                    });
                  }),
            ),
          ])),

      // Plan save tag in replacement of the nav bar
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.only(left: 50.0, right: 50.0),

          // Keep all the button spaced evenly and centered on the page
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              // Plan button
              TextButton(
                  key: const Key("planButton"),
                  child: const Text('Plan'),
                  onPressed: () {}),
              /*
                  * Tag button
                  * Will create a multi select dialog field that will allow
                  * users to select the tags for the Journal Entry
                  */
              TextButton(
                  key: const Key("tagButton"),
                  child: const Text('Tag'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return StatefulBuilder(
                            builder: (stfContext, stfSetState) {
                          return AlertDialog(
                            title: const Text("Select Tags"),
                            content: Wrap(
                              spacing: 5.0,
                              children: settings.tagList.map((Tag tag) {
                                return FilterChip(
                                  label: Text(tag.name),
                                  selected: _selectedTags.contains(tag),
                                  showCheckmark: false,
                                  selectedColor: tag.color,
                                  onSelected: (bool selected) {
                                    stfSetState(() {
                                      setState(() {
                                        if (selected) {
                                          _selectedTags.add(tag);
                                        } else {
                                          _selectedTags.remove(tag);
                                        }
                                      });
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Approve'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                      },
                    );
                  }),

              // Save button
              TextButton(
                  key: const Key("saveButton"),
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.pop(context, getEntry());
                  }),
            ],
          )),
    );
  }

  // Make an Alert Dialog Box that will display the emotional dial and a save button
  dynamic _emotionalDial(BuildContext context, Emotion emotion) async {
    int strength = 0;
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
                              // on changed, set the strength
                              strength = value.round();
                              return '${value.round()}';
                            }()),
                            const Text('progress'),
                          ],
                        )),
              ),
            ),
            actions: [
              // pop the alert dialog off the screen and don't save the strength changes
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),

              // Save the strength changes and pop the dialog off the screen
              TextButton(
                  onPressed: () {
                    emotion.strength = strength;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }

  // Make the journal entry and save it
  getEntry() {
    return JournalEntry(
      id: UniqueKey().hashCode,
      title: titleController.text,
      entryText: journalController.text,
      date: DateTime.now(),
      tags: _selectedTags,
      emotions: _selectedEmotions,
    );
  }
}
