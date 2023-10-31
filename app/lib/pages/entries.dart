import 'package:app/pages/plans.dart';
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
  final items = List<String>.generate(1, (i) => 'Entry $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: const Text('Dismissible Sample')),
        body: SafeArea(
      child: Column(
        children: [
          const Text('Entries'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PlansPage.route());
              },
              child: const Text('nextPagePlans')),
          //holds the list of entries
          Expanded(
              child: ListView.builder(
            itemCount: items.length,
            /*prototypeItem: ListTile(
                  title: Text(items.first),
                ),*/
            itemBuilder: (context, index) {
              final item = items[index];

              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(item),

                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    items.removeAt(index);
                  });

                  // Then show a snackbar.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$item dismissed')));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(item),
                ),
              );
            },
          )
              //ListViewBuilder(),
              )
        ],
      ),
    ));
  }
}
