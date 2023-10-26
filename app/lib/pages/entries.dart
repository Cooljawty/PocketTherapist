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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Text('Entries'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(PlansPage.route());
                  },
                  child: const Text('nextPagePlans')),
              //box SizedBox keeps the plan, tag, and save buttons on the bottom.
              const Expanded(child: SizedBox(height: 1)),
              //Row for overflow widget
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Bar()],
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
        color: Theme.of(context).colorScheme.background,
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