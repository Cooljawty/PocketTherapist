import 'package:app/provider/entry.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/new_entry.dart';
import 'package:provider/provider.dart';
import '../uiwidgets/decorations.dart';


// Display options
final List<String> displayOptions = ['Week', 'Month', 'Year'];
String? chosenDisplay = 'Week';

// Sort the Journal entries by most recent date
late List<JournalEntry> sortedItems;
bool showAllItems = true;

// items = journal entry list;
// chosenDisplay = 'Week', 'Month', 'Year';
// getCompletedList = print the completed list
List<JournalEntry> getFilteredList(
    List<JournalEntry> items, String? chosenDisplay, bool getCompleteList) {
// Sort the Journal entries by most recent date
  final sortedItems = items..sort();
  List<JournalEntry> filteredList = [];

  for (int i = 0; i < sortedItems.length; i++) {
    if (getCompleteList) {
      filteredList.add(sortedItems[i]);
    } else {
      final firstItem = sortedItems[0]; // get the most recent entry
      final item = sortedItems[i]; // get the next item
      final time = firstItem.date; // get the date for the first item

      // check to see if the item is in the filter
      bool isSameDate = time.isSameDate(item.date, chosenDisplay!);

      if (isSameDate) {
        // if item is in the filter, add it to the return list
        filteredList.add(sortedItems[i]);
      }
    }
  }
  return filteredList;
}

class EntryPanelPage extends StatefulWidget {
  const EntryPanelPage({super.key});

  @override
  State<EntryPanelPage> createState() => _EntryPanelPageState();
}

class _EntryPanelPageState extends State<EntryPanelPage> {
  @override
  Widget build(BuildContext context) {
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
                      final time = item.date;

                      // Dividers by filter
                      bool isSameDate = true;
                      if (index == 0) {
                        // if first in list
                        isSameDate = false;
                      } else {
                        // else check if same date by filters
                        isSameDate = time.isSameDate(
                            sortedItems[index - 1].date, chosenDisplay!);
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // if not same date or first in list make new list
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
                              key: Key(item.id.toString()),

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
          bottomNavigationBar: CustomNavigationBar(selectedIndex: 1,)
        );
      },
    );
  }

}

class ExistingEntryPage extends StatefulWidget {
  final JournalEntry entry;
  /// Route for navigator to open page with a given entry
  static Route<dynamic> route({required JournalEntry entry}) {
    return MaterialPageRoute(builder: (context) => ExistingEntryPage(entry: entry));
  }

  const ExistingEntryPage({super.key, required this.entry});

  @override
  State<ExistingEntryPage> createState() => _ExistingEntryPageState();
}

class _ExistingEntryPageState extends State<ExistingEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Title
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(widget.entry.title),
                ],
              ),
            ),

            // Tags
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(direction: Axis.horizontal, children: [
                for (var i in widget.entry.tags)
                  Text("#${i.name} ",
                      style: TextStyle(
                          inherit: true,
                          color: i.color,
                          fontWeight: FontWeight.bold),
                      selectionColor: i.color)
              ]),
            ),

            // Emotions
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  for (var i in widget.entry.emotions)
                    Text("${i.name}: ${i.strength} ",
                        style: TextStyle(
                            inherit: true,
                            color: i.color,
                            fontWeight: FontWeight.bold),
                        selectionColor: i.color)
                ],
              ),
            ),

            //Entry text
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(widget.entry.entryText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
