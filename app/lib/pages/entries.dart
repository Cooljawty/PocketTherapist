import 'dart:core';
import 'package:app/provider/entry.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiwidgets/decorations.dart';

// Display options
const List<String> displayOptions = ['Week', 'Month', 'Year'];
final List<DropdownMenuItem<String>> displayDropDown = displayOptions
    .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
    .toList();
String chosenDisplay = 'Week';

//
// /// [getFilteredList] returns a list that is filtered by the [chosenDisplay] (week, month, year)
// /// [items] = journal entry list;
// /// [chosenDisplay] = 'Week', 'Month', 'Year';
// /// [getCompletedList] = print the completed list
// List<JournalEntry> getFilteredList(
//     List<JournalEntry> items, String? chosenDisplay, bool getCompleteList) {
// // Sort the Journal entries by most recent date
//   final sortedItems = items..sort();
//   List<JournalEntry> filteredList = [];
//
//   for (int i = 0; i < sortedItems.length; i++) {
//     if (getCompleteList) {
//       filteredList.add(sortedItems[i]);
//     } else {
//       final firstItem = sortedItems[0]; // get the most recent entry
//       final item = sortedItems[i]; // get the next item
//       final time = firstItem.date; // get the date for the first item
//
//       // check to see if the item is in the filter
//       bool isSameDate = time.isWithinDateRange(item.date, chosenDisplay!);
//
//       if (isSameDate) {
//         // if item is in the filter, add it to the return list
//         filteredList.add(sortedItems[i]);
//       }
//     }
//   }
//   return filteredList;
// }

/// [EntryPanelPage] is the page for all of the entries that user has entered.
class EntryPanelPage extends StatefulWidget {
  final bool showPlans;

  /// [showPlans] to show either regular entries or plans
  const EntryPanelPage({super.key, this.showPlans = false});

  @override
  State<EntryPanelPage> createState() => _EntryPanelPageState();
}

class _EntryPanelPageState extends State<EntryPanelPage> {
  bool showAllItems = true;

  @override
  Widget build(BuildContext context) {
    // Sort the Journal entries by most recent date
    //sortedItems = getFilteredList(entries, chosenDisplay, showAllItems);

    // Select appropriate list to display
    entries.sort();
    plans.sort();
    List<JournalEntry> items = widget.showPlans ? plans : entries;
    // items.sort();
    return Consumer<ThemeSettings>(
      builder: (context, value, child) {
        return Scaffold(
            body: Stack(children: [
              // This is not const, it changes with theme, don't set it to be const
              // no matter how much the flutter gods beg
              // ignore: prefer_const_constructors
              StarBackground(),

              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.showPlans
                        ? const Text("Plans")
                        : const Text('Entries'),

                    // Pad filter to the right

                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        // Dropdown for filter by date
                        child: DropdownButtonFormField<String>(
                          key: const Key("SortByDateDropDown"),
                          borderRadius: BorderRadius.circular(10.0),
                          // Set up the dropdown menu items
                          value: chosenDisplay,
                          items: displayDropDown,
                          // if changed set new display option
                          onChanged: (item) => setState(() {
                            chosenDisplay = item ?? chosenDisplay;
                          }),
                        ),
                      ),
                    ]),

                    //holds the list of entries
                    Expanded(
                        child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        // get one item
                        final item = items[index];
                        final time = item.date;

                        // Dividers by filter
                        bool isSameDate = true;
                        if (index == 0) {
                          // if first in list
                          isSameDate = false;
                        } else {
                          // else check if same date by filters
                          isSameDate = time.isWithinDateRange(
                              items[index - 1].date, chosenDisplay);
                        }
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // if not same date or first in list make new list
                            children: [
                              if (index == 0 || !(isSameDate)) ...[
                                Text(getTimeRange(time))
                              ],
                              Dismissible(
                                // Each Dismissible must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.

                                // Issue with the key, needs to be specific id, not a
                                // name or will receive error that dismissible is still
                                // in the tree
                                key: Key(item.id.toString()),

                                //prevents right swipes
                                direction: DismissDirection.endToStart,

                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) {
                                  // Remove the item from the data source.
                                  setState(() {
                                    JournalEntry entry = items.removeAt(index);
                                    if (!widget.showPlans) {
                                      entries.remove(entry);
                                    } else {
                                      plans.remove(entry);
                                    }
                                  });

                                  // Then show a snackBar w/ item name as dismissed message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('${item.title} deleted')));
                                },
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete Entry?"),
                                        content: const Text(
                                            "Are you sure you wish to delete this entry?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: DisplayCard(entry: item),
                              )
                            ]); // if in the same filter header list, then just make a new entry
                      },
                    )),
                  ],
                ),
              ),
            ]),
            bottomNavigationBar: CustomNavigationBar(
                selectedIndex: widget.showPlans ? 4 : 1,

                /// We need a custom navigator here because the page needs to update when a new entry is made, but make new entry should be separate from everything else.
                onDestinationSelected: (index) async {
                  switch (index) {
                    case 2:
                      await makeNewEntry(context);
                      setState(() {});
                      return;
                    case 5:
                      Navigator.of(context).pushNamed(
                          CustomNavigationBar.defaultDestinations[index].label);
                      return;
                    case _:
                      Navigator.of(context).pushReplacementNamed(
                          CustomNavigationBar.defaultDestinations[index].label);
                      break;
                  }
                }));
      },
    );
  }

  String getTimeRange(DateTime time) {
    if (chosenDisplay == 'Week') {
      DateTime firstOfYear = DateTime(DateTime.now().year, 1, 1);
      int weekNum = firstOfYear.getWeekNumber(firstOfYear, time);
      DateTime upper = firstOfYear.add(Duration(days: (weekNum * 7)));
      DateTime lower = upper.subtract(const Duration(days: 6));

      // Range for the week
      return '${lower.formatDate()} ${lower.day.toString()} - ${upper.formatDate()} ${upper.day.toString()}, ${time.year.toString()}';
    } else if (chosenDisplay == 'Month') {
      // If monthly, only display month and year
      return '${time.formatDate()} ${time.year.toString()}';
    } else {
      // If yearly, only display year
      return time.year.toString();
    }
  }
}

/// [EntryPage] is the page where an individual entry is displayed. it handles both
/// creation of new entries, modification of them.
class EntryPage extends StatefulWidget {
  final JournalEntry? entry;

  const EntryPage({super.key, this.entry});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final ValueNotifier<double> progress = ValueNotifier(0);
  DateTime? datePicked;
  bool isPlan = false;

  // List of selected tags to keep track of when making the chip list
  List<Tag> selectedTags = [];
  List<Emotion> selectedEmotions = [];

  // Add text controllers to retrieve text data
  final titleController = TextEditingController();
  final entryTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      selectedTags = widget.entry!.tags;
      selectedEmotions = widget.entry!.emotions;
      titleController.text = widget.entry!.title;
      entryTextController.text = widget.entry!.entryText;
      datePicked = widget.entry!.date;
    } else {
      selectedTags = [];
      selectedEmotions = [];
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    entryTextController.dispose();
    super.dispose();
  }

  List<FilterChip> createAvailableTagsList(StateSetter stfSetState) {
    return tagList
        .map((tag) => FilterChip(
              label: Text(tag.name),
              selected: selectedTags.any((element) => element.name == tag.name),
              showCheckmark: false,
              selectedColor: tag.color,
              onSelected: (bool selected) {
                stfSetState(() {
                  setState(() {
                    /// When the corresponding tag is selected, add it or remove it based on the name
                    //TODO: Update this when references are added to work only with references.
                    selected
                        ? selectedTags.add(tag)
                        : selectedTags
                            .removeWhere((element) => element.name == tag.name);
                  });
                });
              },
            ))
        .toList();
  }

  List<FilterChip> createAvailableEmotionsList(StateSetter stfSetState) {
    return emotionList.entries
        .map((e) => FilterChip(
              label: Text(e.key),
              selected:
                  selectedEmotions.any((element) => element.name == e.key),
              showCheckmark: false,
              selectedColor: e.value,
              onSelected: (bool selected) {
                stfSetState(() {
                  setState(() {
                    /// When the corresponding emote is selected, add it or remove it based on the name
                    //TODO: Update this when references are added to work only with references.
                    selected
                        ? selectedEmotions
                            .add(Emotion(name: e.key, color: e.value))
                        : selectedEmotions
                            .removeWhere((element) => element.name == e.key);
                  });
                });
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : widget.entry!.title),
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
                    controller: entryTextController,
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
                        children: selectedTags
                            .map((tag) => ActionChip(
                                  label: Text(tag.name),
                                  backgroundColor: tag.color,
                                  onPressed: () {
                                    setState(() {
                                      selectedTags.removeWhere((element) =>
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
                              children: selectedEmotions
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
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 3,
        allowReselect: true,
        destinations: const [
          NavigationDestination(
              key: Key("planButton"),
              icon: Icon(Icons.more_time),
              label: "Plan"),
          NavigationDestination(
              key: Key("tagButton"), icon: Icon(Icons.tag), label: "Tags"),
          NavigationDestination(
              key: Key("emotionButton"),
              icon: Icon(Icons.emoji_emotions),
              label: "Emotions"),
          NavigationDestination(
              key: Key("saveButton"), icon: Icon(Icons.save), label: "Save"),
        ],
        onDestinationSelected: (index) async {
          switch (index) {
            case 0:
              datePicked = await pickPlanDate();
              isPlan = datePicked != null;
            case 1:
              showTagPicker();
            case 2:
              showEmotionPicker();
            case 3:
              Navigator.pop(context, getEntry());
          }
        },
      ),
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
              maxProgress: 60,
              barWidth: 8,
              startAngle: 5,
              sweepAngle: 360,
              strokeCap: StrokeCap.butt,
              progressGradientColors: [
                emotion.color.withAlpha(128),
                emotion.color,
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
              valueNotifier: progress,

              /// TODO: Remove the child center that displays the strength?
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: progress,
                    builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(() {
                              // on changed, set the strength
                              strength = value.round();
                              return '${value.round()}';
                            }()),
                            const Text('Strength'),
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

  // Date picker
  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDate: datePicked ?? DateTime.now(),
      );

  // Time picker
  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

  Future<DateTime?> pickPlanDate() async {
    var selectedDate = await pickDate();
    if (selectedDate == null) return null;

    var selectedTime = await pickTime();
    if (selectedTime == null) return null;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  void showTagPicker() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          return AlertDialog(
            title: const Text("Select Tags"),
            content: Wrap(
              spacing: 5.0,
              children: createAvailableTagsList(stfSetState),
            ),
            actions: <Widget>[
              TextButton(
                key: const Key('saveTagsButton'),
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(stfContext).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showEmotionPicker() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          return AlertDialog(
            title: const Text("Select Emotions"),
            content: Wrap(
              spacing: 5.0,
              children: createAvailableEmotionsList(stfSetState),
            ),
            actions: <Widget>[
              TextButton(
                key: const Key('saveEmotionsButton'),
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(stfContext).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  // Make the journal entry and save it
  JournalEntry? getEntry() {
    // Database entry point for creating journal entry
    if (widget.entry == null) {
      //TODO: do database things to save new journal entry: db.insert
      return JournalEntry(
        title: titleController.text,
        entryText: entryTextController.text,
        tags: selectedTags,
        emotions: selectedEmotions,
        planCompleted: isPlan ? false : null,
        date: datePicked ?? DateTime.now(),
      );
    } else {
      // entry exists, we are modifying
      //TODO: do database things for updating journal entry
      // I have the full record, just patch the record.
      widget.entry!.update(titleController.text, entryTextController.text,
          selectedTags, selectedEmotions, datePicked);
      return widget.entry!;
    }
  }
}

/// [Formatter] is an extended DateTime Object that
extension Formatter on DateTime {
  // Get the month string
  String formatDate() {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Date is Wrong'; // This should never happen
    }
  }

  // Check if entries are in the same filter date
  bool isWithinDateRange(DateTime other, String display) {
    switch (display) {
      // If week filter, then check if in the same year, month, and week
      case 'Week':
        final firstWeek = DateTime(DateTime.now().year, 1, 1);
        return (year == other.year &&
            month == other.month &&
            (getWeekNumber(firstWeek, this) ==
                getWeekNumber(firstWeek, other)));
      // if month filter, then check for same year and month
      case 'Month':
        return (year == other.year && month == other.month);
      // if year filter, then check for same year
      case 'Year':
        return (year == other.year);
      // This should never happen
      default:
        return false;
    }
  }

  // get the week number for DateTime math in headers and filters
  int getWeekNumber(DateTime start, DateTime end) {
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day);

    // return the difference between the start and end date by week rounded up
    return (end.difference(start).inDays / 7).ceil();
  }
}
