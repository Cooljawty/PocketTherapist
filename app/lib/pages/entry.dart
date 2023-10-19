import 'package:app/pages/entries.dart';
import 'package:flutter/material.dart';

class EntryPage<T> extends StatefulWidget {
	final Map<String,String> entry;

	/// Route for navigator to open page with a given entry
  static Route<dynamic> route({entry}) {
    return MaterialPageRoute(builder: (context) => EntryPage(entry: entry));
  }

  const EntryPage({super.key, required this.entry});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: SafeArea(
				child: Column(
						children: <Widget>[ 
							Text( "${widget.entry['title']}"),
							Text( "${widget.entry['entryText']}"), 

							ElevatedButton(onPressed: (){
								Navigator.of(context).pushReplacement(EntriesPage.route());

							}, child: const Text('nextPageEntries') )
						],
				),
			),
    );
  }
}
