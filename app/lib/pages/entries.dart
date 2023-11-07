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
  //Generated list of strings
  static List<JournalEntry> entries = [
    JournalEntry(title: "Entry 1", entryText: "", date: DateTime(2020, 2, 26)),                   // same day
    JournalEntry(title: "Entry 2", entryText: "", date: DateTime(2020, 2, 26)),                   //--------------
    JournalEntry(title: "Entry 3", entryText: "", date: DateTime(2021, 2, 26)),                 // same month
    JournalEntry(title: "Entry 4", entryText: "", date: DateTime(2021, 2, 30)),                 //--------------
    JournalEntry(title: "Entry 5", entryText: "", date: DateTime(2021, 3, 30)),
    JournalEntry(title: "Entry 6", entryText: "", date: DateTime(2021, 5, 30)),
    JournalEntry(title: "Entry 7", entryText: ":3", date: DateTime(2019, 2, 26)),
    JournalEntry(title: "Entry 8", entryText: ">:3", date: DateTime(2023, 2, 26)),
  ];
  final items = entries;

  // Display options
  List<String> displayOptions = ['Day', 'Month', 'Year'];
  String? chosenDisplay = 'Day';

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
                        Navigator.of(context).pushReplacement(PlansPage.route());
                      },
                      child: const Text('nextPagePlans')),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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

                    // if changed set the new theme
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
                final sortedItems = items..sort((item1,item2) => item2.getDate().compareTo(item1.getDate()));
                final item = sortedItems[index];

                // Dividers by day
                bool isSameDate = true;
                if(index ==0){
                  isSameDate = false;
                }else{
                  isSameDate = item.getDate().isSameDate(sortedItems[index - 1].getDate(), chosenDisplay!);
                }
                if(index == 0 || !(isSameDate)){
                  return Column(
                    children: [
                      Text((() {
                        if(chosenDisplay == 'Day'){
                            return '${item.getDate().formatDate()} ${item.getDate().day.toString()}, ${item.getDate().year.toString()}';
                        }else if(chosenDisplay == 'Month'){
                            return '${item.getDate().formatDate()} ${item.getDate().year.toString()}';
                        }
                        else{
                            return item.getDate().year.toString();
                        }

                      })()),
                      Dismissible(

                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(item.getTitle()),
                        //prevents right swipes
                        direction: DismissDirection.endToStart,

                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                        // Remove the item from the data source.
                        setState(() {
                        items.removeAt(index);
                        });

                        // Then show a snackBar.
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('${item.getTitle()} dismissed')));
                        },
                        // Show a red background as the item is swiped away.
                        // background: Container(
                        // 	color: Colors.red,
                        // ),
                        child: item.asDisplayCard(),
                      ),
                    ],
                  );
                } else{
                  return Dismissible(

                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                    key: Key(item.getTitle()),
                    //prevents right swipes
                    direction: DismissDirection.endToStart,

                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        items.removeAt(index);
                      });

                      // Then show a snackBar.
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('${item.getTitle()} dismissed')));
                    },
                    // Show a red background as the item is swiped away.
                    // background: Container(
                    // 	color: Colors.red,
                    // ),
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
              const Bar(),
              FloatingActionButton(
                //add key for testing
                onPressed: () {
                  Navigator.push(
                    // Go to settings page
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()));
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

extension DateHelper on DateTime {

  String formatDate() {
    switch (month){
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
      default: return 'Date is Wrong';
    }
  }
  bool isSameDate(DateTime other, String display) {
    switch(display) {
      case 'Day': return (year == other.year && month == other.month && day == other.day);
      case 'Month': return (year == other.year && month == other.month);
      case 'Year': return (year == other.year);
      default: return (year == other.year && month == other.month && day == other.day);
    }
  }
}
