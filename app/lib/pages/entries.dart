import 'package:app/pages/plans.dart';
import 'package:app/uiwidgets/cards.dart';
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
			  DisplayCard(content: ["Test text"]),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(PlansPage.route());
              }, child: const Text('nextPagePlans') )
            ],
          ),
        )
    );
  }
}
