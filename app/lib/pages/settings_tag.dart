import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TagSettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const TagSettingsPage());
  }

  const TagSettingsPage({super.key});

  @override
  State<TagSettingsPage> createState() => _TagSettingsState();
}

class _TagSettingsState extends State<TagSettingsPage> {
  List<String> tagList = [
    'a',
    'aa',
    'aaa',
    'b',
    'bb',
    'bbb',
    'ab',
    'aabb',
    'aaabbb',
  ];
  List<String>? compatableTagList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          TextFormField(
            key: const Key('TagSearchBar'),
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: null,
            validator: null,
          ),
          const SingleChildScrollView(
            child: Text('List of Tags'),
          ),
        ],
      ),
    ));
  }
}
