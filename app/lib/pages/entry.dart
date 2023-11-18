import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/helper/classes.dart';

import 'dart:math';

class JournalEntry with DisplayOnCard {
  // unique id for each entry
  final int _id = UniqueKey().hashCode;

  // Journal entry title and body
  String _title = "";
  String _entryText = "";
  String _previewText = "";

  // year, month, day
  DateTime current = DateTime.now();
  DateTime _date = DateTime(1970, 12, 31);
  List<Tag> _tags = [];
  List<Emotion> _emotions = [];

  static const previewLength = 25;

  JournalEntry(
      {required title, required entryText, required date, tags, emotions}) {
    _title = title;
    _entryText = entryText;
    _date = date;
    _tags = tags ?? [];
    _emotions = emotions ?? [];

    final preview = _entryText.split("\n").first;
    _previewText = preview.substring(0, min(previewLength, preview.length));

    card = (
      body: getEntryText(),
      date: _date,
      emotionList: _emotions,
      tagList: _tags,
      title: _title,
    );

    pageRoute = (() => EntryPage.route(entry: this));
  }
  int getID() => _id;
  String getPreviewText() => _previewText;
  String getEntryText() => _entryText;
  String getTitle() => _title;
  DateTime getDate() => _date;
  List<Tag> getTags() => _tags;
  List<Emotion> getEmotions() => _emotions;

  // Get the strongest emotion in the entry
  Emotion getStrongestEmotion() {
    if (_emotions.isNotEmpty) {
      Emotion strongestEmotion = _emotions[0];
      for (int i = 1; i < _emotions.length; i++) {
        (strongestEmotion.strength < _emotions[i].strength)
            ? strongestEmotion = _emotions[i]
            : 0;
      }
      return strongestEmotion;
    }
    return Emotion(
        name: 'None', strength: 0, color: Colors.black); // This shouldn't happen
  }

  /* TODO
	List<Image> pictures;

	Tag getTagByTitle(String title);
	List<Image> getPictures();
	*/
}

class EntryPage extends StatefulWidget {
  final JournalEntry entry;

  /// Route for navigator to open page with a given entry
  static Route<dynamic> route({required JournalEntry entry}) {
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
        child: Center(
          child: Column(
            children: <Widget>[
              //Title
              Container(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Text(widget.entry.getTitle()),
                  ],
                ),
              ),

              // Tags
              Container(
                padding: const EdgeInsets.all(12),
                child: Wrap(direction: Axis.horizontal, children: [
                  for (var i in widget.entry.getTags())
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
                    for (var i in widget.entry.getEmotions())
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
                    Text(widget.entry.getEntryText()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
