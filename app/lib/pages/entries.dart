import 'package:app/pages/plans.dart';
import 'package:app/pages/entry.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';

class EntriesPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const EntriesPage());
  }

  const EntriesPage({super.key});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  //Generated list of journal entries
  static List<JournalEntry> entries = [
    JournalEntry(title: "Entry 1", entryText: '', date: DateTime(2020, 2, 15)),
    JournalEntry(title: "Entry 2", entryText: '', date: DateTime(2020, 2, 18)),
    JournalEntry(title: "Entry 3", entryText: '', date: DateTime(2020, 2, 19)),
    JournalEntry(title: "Entry 4", entryText: '', date: DateTime(2020, 2, 21)),
    JournalEntry(title: "Entry 5", entryText: '', date: DateTime(2020, 2, 25)),
    JournalEntry(title: "Entry 6", entryText: '', date: DateTime(2020, 2, 27)),
    JournalEntry(title: "Entry 7", entryText: '', date: DateTime(2020, 2, 29)),
  ];
  final items = entries;

  // Display options
  List<String> displayOptions = ['Week', 'Month', 'Year'];
  String? chosenDisplay = 'Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: Column(
        children: [
          const Text('Entries'),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(PlansPage.route());
                      },
                      child: const Text('nextPagePlans')),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // Dropdown for filter by date
                  child: DropdownButtonFormField<String>(
                    // Make the grey background
                    dropdownColor: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.0),

                    // Set up the dropdown menu items
                    value: chosenDisplay,
                    items: displayOptions
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.black),
                            )))
                        .toList(),

                    // if changed set new display option
                    onChanged: (item) => setState(() {
                      chosenDisplay = item;
                    }),
                  ),
                ),
              ),
            ],
          ),

          //holds the list of entries
          Expanded(
              child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
              // Sort the Journal entries by most recent date
              final sortedItems = items
                ..sort((item1, item2) => item2.getDate().compareTo(item1.getDate()));

              final item = sortedItems[index];
              final time = item.getDate();

              // Dividers by filter
              bool isSameDate = true;
              if (index == 0) {       // if first in list
                isSameDate = false;
              } else {                // else check if same date by filters
                isSameDate = time.isSameDate(sortedItems[index - 1].getDate(), chosenDisplay!);
              }
              if (index == 0 || !(isSameDate)) {    // if not same date or first in list make new list
                return Column(
                  children: [
                    Text((() {
                      // If weekly view, then calculate weeks of the year and display range in header
                      if (chosenDisplay == 'Week') {
                        DateTime firstOfYear = DateTime(DateTime.now().year, 1, 1);
                        int weekNum = firstOfYear.getWeekNumber(firstOfYear, time);
                        DateTime upper = firstOfYear.add(Duration(days: (weekNum * 7)));
                        DateTime lower = upper.subtract(const Duration(days: 6));

                        // Range for the week
                        return '${lower.formatDate()} ${lower.day.toString()} - ${upper.formatDate()} ${upper.day.toString()}';
                      } else if (chosenDisplay == 'Month') {
                        // If monthly, only display month and year
                        return '${time.formatDate()} ${time.year.toString()}';
                      } else {
                        // If yearly, only display year
                        return time.year.toString();
                      }
                    })()),
                    // Make Dismissible card per journal entry
                    Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(item.getTitle()),  // this has to change later
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${item.getTitle()} dismissed')));
                      },
                      // Show a red background as the item is swiped away.
                      // background: Container(
                      // 	color: Colors.red,
                      // ),
                      child: item.asDisplayCard(),
                    ),
                  ],
                );
              } else {  // if in the same filter header list, then just make a new entry
                return Dismissible(
                  key: Key(item.getTitle()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      items.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${item.getTitle()} dismissed')));
                  },
                  child: item.asDisplayCard(),
                );
              }
            },
          )
              //ListViewBuilder(),
              ),
          //Row for overflow widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Plan, tag, save bar
              const Bar(),

              // temp settings button
              FloatingActionButton(
                //add key for testing
                onPressed: () {
                  Navigator.push(
                      // Go to settings page
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                tooltip: 'Settings',
                shape: const CircleBorder(eccentricity: 1.0),
                child: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class Bar extends StatelessWidget {
  const Bar({super.key});

  @override
  //Creates the OverflowBar for the plan, tag, and save buttons
  Widget build(BuildContext context) {
    return Container(
        color: getCurrentTheme().colorScheme.onBackground,
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
                    onPressed: () {}),
              ],
            )
          ],
        ));
  }
}

extension Formatter on DateTime {

  // Get the month string
  String formatDate() {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return 'Date is Wrong';  // This should never happen
    }
  }

  // Check if entries are in the same filter date
  bool isSameDate(DateTime other, String display) {
    switch (display) {
      // If week filter, then check if in the same year, month, and week
      case 'Week':
        final firstWeek = DateTime(DateTime.now().year, 1, 1);
        return (year == other.year && month == other.month && (getWeekNumber(firstWeek, this) == getWeekNumber(firstWeek, other)));
     // if month filter, then check for same year and month
      case 'Month': return (year == other.year && month == other.month);
      // if year filter, then check for same year
      case 'Year': return (year == other.year);
      // This should never happen
      default: return false;
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
