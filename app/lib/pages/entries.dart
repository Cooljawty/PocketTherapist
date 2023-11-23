import 'package:app/pages/entry.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/new_entry.dart';
import 'package:app/uiwidgets/navbar.dart';
import 'package:provider/provider.dart';
import '../uiwidgets/decorations.dart';
// import 'package:app/helper/classes.dart';

class EntriesPage extends StatefulWidget {
  final bool showPlans;

  static Route<dynamic> route({required bool showPlans}) {
    return MaterialPageRoute(
        builder: (context) => EntriesPage(showPlans: showPlans));
  }

  const EntriesPage({super.key, this.showPlans = false});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

List<JournalEntry> entries = [
  // JournalEntry(
  //     title: "Location: Paris, France",
  //     entryText:
  //         'Today was my first day in Paris and it was absolutely magical. I woke up early and headed straight to the '
  //         'Eiffel Tower to catch the sunrise. The view from the top was breathtaking, with the sun just peeking over the horizon '
  //         'and casting a warm glow over the city.',
  //     date: DateTime(2022, 7, 12),
  //     tags: [
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Present', color: const Color(0xffff7070)),
  //       Tag(name: 'Content', color: const Color(0xfff1903b)),
  //       Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 90),
  //       Emotion(name: 'Anger', color: const Color(0xffb51c1c), strength: 70),
  //     ]),
  // JournalEntry(
  //     title: "What are my core values and how do they impact my decisions?",
  //     entryText:
  //         'Today I’ve been considering my core values and how they impact the decisions I make in my life. I realize '
  //         'that my values are an essential part of who I am, and they play a significant role in shaping my thoughts, actions, '
  //         'and choices.',
  //     date: DateTime(2023, 1, 15),
  //     tags: [
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 40),
  //       Emotion(name: 'Trust', color: const Color(0xff308c7e), strength: 70),
  //     ]),
];


List<JournalEntry> items = [];
List<JournalEntry> entry =
    entries.where((entry) => entry.status == PlanStatus.noPlan).toList();
List<JournalEntry> plans =
    entries.where((entry) => entry.status != PlanStatus.noPlan).toList();

// Display options
final List<String> displayOptions = ['Week', 'Month', 'Year'];
String? chosenDisplay = 'Week';

// Sort the Journal entries by most recent date
late List<JournalEntry> sortedItems;
bool showAllItems = true;

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    var items = widget.showPlans ? plans : entry;
    // Sort the Journal entries by most recent date
    sortedItems = getFilteredList(items, chosenDisplay, showAllItems);
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
                  widget.showPlans ? const Text("Plans") : const Text('Entries'),

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
                        items: displayOptions
                            .map((item) => DropdownMenuItem<String>(
                                value: item, child: Text(item)))
                            .toList(),
                        // if changed set new display option
                        onChanged: (item) => setState(() {
                          chosenDisplay = item;
                        }),
                      ),
                    ),
                  ]),

                  //holds the list of entries
                  Expanded(
                      child: ListView.builder(
                    itemCount: sortedItems.length,
                    itemBuilder: (context, index) {
                      // get one item
                      final item = sortedItems[index];
                      final time = item.getDate();

                      // Dividers by filter
                      bool isSameDate = true;
                      if (index == 0) {
                        // if first in list
                        isSameDate = false;
                      } else {
                        // else check if same date by filters
                        isSameDate = time.isSameDate(
                            sortedItems[index - 1].getDate(), chosenDisplay!);
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // if not same date or first in list make new list
                          children: [
                            if (index == 0 || !(isSameDate)) ...[
                              Text(() {
                                // If weekly view, then calculate weeks of the year and display range in header
                                if (chosenDisplay == 'Week') {
                                  DateTime firstOfYear =
                                      DateTime(DateTime.now().year, 1, 1);
                                  int weekNum = firstOfYear.getWeekNumber(
                                      firstOfYear, time);
                                  DateTime upper = firstOfYear
                                      .add(Duration(days: (weekNum * 7)));
                                  DateTime lower =
                                      upper.subtract(const Duration(days: 6));

                                  // Range for the week
                                  return '${lower.formatDate()} ${lower.day.toString()} - ${upper.formatDate()} ${upper.day.toString()}, ${time.year.toString()}';
                                } else if (chosenDisplay == 'Month') {
                                  // If monthly, only display month and year
                                  return '${time.formatDate()} ${time.year.toString()}';
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
                              key: Key(item.getID().toString()),

                              //prevents right swipes
                              direction: DismissDirection.endToStart,

                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  items.removeAt(index);
                                });

                                // Then show a snackBar w/ item name as dismissed message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${item.getTitle()} deleted')));
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
                              child: item.asDisplayCard(),
                            )
                          ]); // if in the same filter header list, then just make a new entry
                    },
                  )),
                  Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            makeNewEntry();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          key: const Key("New Entry"),
                          child: const Icon(Icons.add))),
                ],
              ),
            ),
          ]),
          bottomNavigationBar: NavBar(
            selectedIndex: !widget.showPlans ? 1 : 3,
            destinations: [
              destinations['dashboard']!,
              destinations['entries']!,
              destinations['calendar']!,
              destinations['plans']!,
              destinations['settings']!,
            ],
          ),
        );
      },
    );
  }

  makeNewEntry() async {
    final JournalEntry result =
        await Navigator.push(context, NewEntryPage.route());
    setState(() {
      result.status == PlanStatus.noPlan ? entry.add(result) : plans.add(result);
    });
  }
}

// items = journal entry list;
// chosenDisplay = 'Week', 'Month', 'Year';
// getCompletedList = print the completed list
List<JournalEntry> getFilteredList(
    List<JournalEntry> items, String? chosenDisplay, bool getCompleteList) {
// Sort the Journal entries by most recent date
  final sortedItems = items
    ..sort((item1, item2) => item2.getDate().compareTo(item1.getDate()));
  List<JournalEntry> filteredList = [];

  for (int i = 0; i < sortedItems.length; i++) {
    if (getCompleteList) {
      filteredList.add(sortedItems[i]);
    } else {
      final firstItem = sortedItems[0]; // get the most recent entry
      final item = sortedItems[i]; // get the next item
      final time = firstItem.getDate(); // get the date for the first item

      // check to see if the item is in the filter
      bool isSameDate = time.isSameDate(item.getDate(), chosenDisplay!);

      if (isSameDate) {
        // if item is in the filter, add it to the return list
        filteredList.add(sortedItems[i]);
      }
    }
  }
  return filteredList;
}

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
  bool isSameDate(DateTime other, String display) {
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
