import 'package:flutter/material.dart';

//import 'package:vector_math/vector_math_64.dart';
import 'entry.dart';

import 'package:app/helper/classes.dart';
import 'package:app/provider/settings.dart' as settings;
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
  DateTime? datePicked = DateTime.now();
  bool isPlan = false;

  final ValueNotifier<double> _progress = ValueNotifier(0);

  final _emotionItems = settings.emotionList.entries.map((emotion) {
    return Emotion(name: emotion.key, color: emotion.value);
  }).toList();

  // List of selected tags to keep track of when making the chip list
  final List<Tag> _selectedTags = [];
  final List<Emotion> _selectedEmotions = [];

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
      appBar: AppBar(
        title: const Text('New Entry'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
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
                      key: const Key('TagChipsDisplay'),
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 5,
                        children: _selectedTags
                            .map((tag) => ActionChip(
                                  label: Text(tag.name),
                                  backgroundColor: tag.color,
                                  onPressed: () {
                                    setState(() {
                                      _selectedTags.removeWhere((element) =>
                                          element.name == tag.name);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                // Chip display for the emotions
                Padding(
                    padding: const EdgeInsets.all(20),
                    // Make the chips scrollable
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            key: const Key('EmotionChipsDisplay'),
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 5,
                              children: _selectedEmotions
                                  .map((Emotion emotion) => ActionChip(
                                        label: Text(emotion.name),
                                        backgroundColor: emotion.color,
                                        onPressed: () =>
                                            _emotionalDial(context, emotion),
                                      ))
                                  .toList(),
                            )))),
              ]))),

      // Plan save tag in replacement of the nav bar
      bottomNavigationBar: Container(
          transform: Matrix4.translationValues(0, 3, 0),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  side: BorderSide(
                    width: 3,
                    color: settings.getCurrentTheme().colorScheme.primary,
                  ))),
          margin: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width / 10),
              right: (MediaQuery.of(context).size.width / 10)),

          // Keep all the button spaced evenly and centered on the page
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              // Plan button
              TextButton(
                  key: const Key("planButton"),
                  child: const Text('Plan'),
                  onPressed: () async {
                    isPlan = false;

                    var selectedDate = await pickDate();
                    if (selectedDate == null) return;

                    var selectedTime = await pickTime();
                    if (selectedTime == null) return;

                    datePicked = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    isPlan = true;

                  }),
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
                                        selected
                                            ? _selectedTags.add(tag)
                                            : _selectedTags.remove(tag);
                                      });
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                key: const Key('saveTagsButton'),
                                child: const Text('Save'),
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

              TextButton(
                  key: const Key("emotionButton"),
                  child: const Text('Emotion'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return StatefulBuilder(
                            builder: (stfContext, stfSetState) {
                          return AlertDialog(
                            title: const Text("Select Emotions"),
                            content: Wrap(
                              spacing: 5.0,
                              children: _emotionItems.map((Emotion emote) {
                                return FilterChip(
                                  label: Text(emote.name),
                                  selected: _selectedEmotions.contains(emote),
                                  showCheckmark: false,
                                  selectedColor: emote.color,
                                  onSelected: (bool selected) {
                                    stfSetState(() {
                                      setState(() {
                                        selected
                                            ? _selectedEmotions.add(emote)
                                            : _selectedEmotions.remove(emote);
                                      });
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                key: const Key('saveEmotionsButton'),
                                child: const Text('Save'),
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
              key: const Key('EmotionalDial'),
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
              dashWidth: 26,
              dashGap: 10,
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
                  key: const Key('cancelDial'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),

              // Save the strength changes and pop the dialog off the screen
              TextButton(
                  key: const Key('saveDial'),
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
      title: titleController.text,
      entryText: journalController.text,
      date: isPlan ? datePicked : DateTime.now(),
      tags: _selectedTags,
      emotions: _selectedEmotions,
      plan: isPlan,
    );
  }

  // Date picker
  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: datePicked);

  // Time picker
  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());
}
