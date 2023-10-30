import 'package:flutter/material.dart';

class NewEntryPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const NewEntryPage());
  }
  const NewEntryPage({super.key });

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  // Add text controllers to retrieve text data
  final titleController = TextEditingController();
  final journalController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Text('New Entry'),

              // Title input textfield
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: titleController,
                  key: const Key("titleInput"),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Title',
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),

              // Journal input textfield
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: journalController,
                  key: const Key("journalInput"),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Journal Entry',
                  ),
                  style: const TextStyle(color: Colors.black),
                  maxLines: 8,
                  minLines: 8,
                ),
              ),

              // Button for tags
              // make tag input
              SizedBox(
                  width: 240,
                  child: ElevatedButton(
                      key: const Key("tagButton"),
                      onPressed: () {},
                      child: const Text("Tags")
                  )
              ),

              // Add emotion wheel
            ],
          ),
        ),

      // Save button
      // Make save functionality
      floatingActionButton: FloatingActionButton(
        key: const Key("SaveButton"),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Save")
      ),
    );
  }
}
