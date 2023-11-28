import 'dart:core';
import 'package:app/provider/entry.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiwidgets/decorations.dart';
import 'package:app/helper/dates_and_times.dart';

// Display options
enum DisplayOption{ 
	Week, Month, Year; 
 String toString() => this.name.split('.').last;
}
DisplayOption chosenDisplay = DisplayOption.Week;

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
  const EntryPanelPage({super.key, this.targetDate});

	final DateTime? targetDate;

  static Route<dynamic> route({targetDate}) {
    return MaterialPageRoute(builder: (context) => EntryPanelPage(targetDate: targetDate));
  }

  @override
  State<EntryPanelPage> createState() => _EntryPanelPageState();
}

class _EntryPanelPageState extends State<EntryPanelPage> {
  bool showAllItems = true;
  
  @override
  Widget build(BuildContext context) {
    // Sort the Journal entries by most recent date
		//Show entreis in range of given date or from today
		final today = widget.targetDate ?? DateTime.now();
		final startDate = switch(chosenDisplay) {
			DisplayOption.Week => today.subtract(Duration(days: today.weekday - 1)), 
			DisplayOption.Month => DateTime(today.year, today.month, 1), 
			DisplayOption.Year => DateTime(today.year, 1, 1), 
		};
		final endDate = switch(chosenDisplay) {
			DisplayOption.Week => today.add(Duration(days: 7 - today.weekday)),
			DisplayOption.Month => DateTime(today.year, today.month, 0),
			DisplayOption.Year => DateTime(today.year, 12, 0),
		};
		final filteredEntries = entriesInDateRange( context, startDate, endDate).toList();
    filteredEntries.sort();
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
                  const Text('Entries'),

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
                        value: chosenDisplay.toString(),
                        items: DisplayOption.values
                            .map((item) => DropdownMenuItem<String>(
                                value: item.toString(), child: Text(item.toString())))
                            .toList(),
                        // if changed set new display option
                        onChanged: (item) => setState(() {
                          chosenDisplay = switch(item) {
														"Week" => DisplayOption.Week,
														"Month" => DisplayOption.Month,
														"Year" => DisplayOption.Year,
														_ => DisplayOption.Week,
													} ?? chosenDisplay;
                        }),
                      ),
                    ),
                  ]),

										//holds the list of entries
										Expanded(
												child: ListView.builder(
											itemCount: filteredEntries.length,
											itemBuilder: (context, index) {
												// get one item
												final item = filteredEntries[index];
												final time = item.date;

												// Dividers by filter
												bool isSameDate = true;
												if (index == 0) {
													// if first in list
													isSameDate = false;
												} else {
													// else check if same date by filters
													isSameDate = time.isWithinDateRange(
															filteredEntries[index - 1].date, chosenDisplay.toString());
												}
												return Column(
														mainAxisAlignment: MainAxisAlignment
																.center, // if not same date or first in list make new list
														children: [
															if (index == 0 || !(isSameDate)) ...[
																Text(() {
																	// If weekly view, then calculate weeks of the year and display range in header
																	if (chosenDisplay == DisplayOption.Week) {
																		DateTime firstOfYear =
																				DateTime(DateTime.now().year, 1, 1);
																		int weekNum = firstOfYear.getWeekNumber(
																				firstOfYear, time);
																		DateTime upper = firstOfYear
																				.add(Duration(days: (weekNum * 7)));
																		DateTime lower =
																				upper.subtract(const Duration(days: 6));

																		// Range for the week
																		return '${lower.formatDate().month} ${lower.day.toString()} - ${upper.formatDate().month} ${upper.day.toString()}, ${time.year.toString()}';
																	} else if (chosenDisplay == DisplayOption.Month) {
																		// If monthly, only display month and year
																		return '${time.formatDate().month} ${time.year.toString()}';
																	} else {
																		// If yearly, only display year
																		return time.year.toString();
																	}
																}())
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
																		entries.remove(filteredEntries[index]);
																	});

																	// Then show a snackBar w/ item name as dismissed message
																	ScaffoldMessenger.of(context).showSnackBar(
																			SnackBar(
																					content: Text(
																							'${item.title} deleted')));
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
																									Navigator.of(context).pop(true),
																							child: const Text("DELETE")),
																					TextButton(
																						onPressed: () =>
																								Navigator.of(context).pop(false),
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
							selectedIndex: 1,
							/// We need a custom navigator here because the page needs to update when a new entry is made, but make new entry should be separate from everything else.
							onDestinationSelected: (index) async {
								switch(index) {
									case 2: await makeNewEntry(context); setState((){}); return;
									case 5: Navigator.of(context).pushNamed(CustomNavigationBar.defaultDestinations[index].label); return;
									case _: Navigator.of(context).pushReplacementNamed(CustomNavigationBar.defaultDestinations[index].label); break;
								}
							}
						)
					);
				},
			);
		}
	}

	/// [EntryPage] is the page where an indivudal entry is displayed. it handles both
	/// creation of new entries, modification of them.
class EntryPage extends StatefulWidget {
  final JournalEntry? entry;
  const EntryPage({
    super.key,
    this.entry
  });

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final ValueNotifier<double> progress = ValueNotifier(0);

  // List of selected tags to keep track of when making the chip list
  List<Tag> selectedTags = [];
  List<Emotion> selectedEmotions = [];

  // Add text controllers to retrieve text data
  final titleController = TextEditingController();
  final entryTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.entry != null) {
      selectedTags = widget.entry!.tags;
      selectedEmotions = widget.entry!.emotions;
      titleController.text = widget.entry!.title;
      entryTextController.text = widget.entry!.entryText;
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
    return tagList.map((tag) => FilterChip(
        label: Text(tag.name),
        selected: selectedTags.any((element) => element.name == tag.name),
        showCheckmark: false,
        selectedColor: tag.color,
        onSelected: (bool selected) {
          stfSetState(() {
            setState(() {
              /// When the cooresponding tag is selected, add it or remove it based on the name
              //TODO: Update this when references are added to work only with references.
              selected ? selectedTags.add(tag) : selectedTags.removeWhere((element) => element.name == tag.name);
            });
          });
        },
      )).toList();
  }

  List<FilterChip> createAvailableEmotionsList(StateSetter stfSetState) {
    return emotionList.entries.map((e) => FilterChip(
        label: Text(e.key),
        selected: selectedEmotions.any((element) => element.name == e.key),
        showCheckmark: false,
        selectedColor: e.value,
        onSelected: (bool selected) {
          stfSetState(() {
            setState(() {
              /// When the cooresponding emote is selected, add it or remove it based on the name
              //TODO: Update this when references are added to work only with references.
              selected ? selectedEmotions.add(Emotion(name: e.key, color: e.value)) : selectedEmotions.removeWhere((element) => element.name == e.key);
            });
          });
        },
    )).toList();
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
              child: Column(
                  children: [
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
                            )).toList(),
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
              valueNotifier: progress,
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
  JournalEntry? getEntry() {
    // Database entry point for creating journal entry
    if(widget.entry == null) {
      //TODO: do databse things to save new journal entry: db.insert
      return JournalEntry(
        title: titleController.text,
        entryText: entryTextController.text,
        date: DateTime.now(),
        tags: selectedTags,
        emotions: selectedEmotions,
      );
    } 
    else {
      // entry exists, we are modifying
      //TODO: do datbase things for updating journal entry
      // I have the full record, just patch the record.
      widget.entry!.update(
        titleController.text,
        entryTextController.text,
        selectedTags,
        selectedEmotions
      );
      return widget.entry!;
    }
  }
}

//TODO replace with database
List<JournalEntry> entriesBetween(DateTime start, DateTime end) {
	final testEntries = <JournalEntry>[
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 10, 31), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 11, 1), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 2", entryText: "", 
				date: DateTime(2023, 11, 1), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 11, 2), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 8,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 1", entryText: "", 
				date: DateTime(2023, 11, 3), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 15,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 2", entryText: "", 
				date: DateTime(2023, 11, 3), 
				emotions: [
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 11, 17), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 2", entryText: "", 
				date: DateTime(2023, 11, 25), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 11, 30), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 8,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 1", entryText: "", 
				date: DateTime(2023, 11, 26), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 15,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 2", entryText: "", 
				date: DateTime(2023, 11, 12), 
				emotions: [
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 11, 11), 
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime.now(), 
				emotions: [
					Emotion(
						name: "Happy",
						color: Color(0xfffddd68),
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime(2023, 11, 24), 
				emotions: [
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Out of range entry", entryText: "", 
				date: DateTime(2023, 11, 14), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 30,
					),
				]
			),
		];

	testEntries.retainWhere((e) => ( !e.date.isBefore(start) && !e.date.isAfter(end)));
	testEntries.sort((a, b) => a.date.compareTo(b.date));
	return testEntries;
}
