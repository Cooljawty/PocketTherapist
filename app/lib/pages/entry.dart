import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/helper/classes.dart';

import 'dart:math';

enum PlanStatus {
  noPlan,
  unfinished,
  finished,
}

class JournalEntry with DisplayOnCard {
  // unique id for each entry
  final int _id = UniqueKey().hashCode;

  // Journal entry title and body
  String _title = "";
  String _entryText = "";
  String _previewText = "";

  // year, month, day
  DateTime _creationDate = DateTime.now();
  DateTime _displayDate = DateTime(1970, 12, 31);
  List<Tag> _tags = [];
  List<Emotion> _emotions = [];

  static const previewLength = 40;

  // Plan
  late PlanStatus status;

  JournalEntry({
    required title,
    required entryText,
    required date,
    displayDate,
    tags,
    emotions,
    PlanStatus planStatus = PlanStatus.noPlan,
  }) {
    _creationDate = date;
    _displayDate = displayDate ?? date;
    _title = title;
    _entryText = entryText;
    _tags = tags ?? [];
    _emotions = emotions ?? [];
    status = planStatus;

    final preview = _entryText.split("\n").first;
    _previewText = preview.substring(0, min(previewLength, preview.length));

    card = (
      body: _previewText,
      date: _displayDate,
      emotionList: _emotions,
      tagList: _tags,
      title: _title,
      planStatus: status
    );

    pageRoute = (() => EntryPage.route(entry: this));
  }

  int getID() => _id;

  String getPreviewText() => _previewText;

  String getEntryText() => _entryText;

  String getTitle() => _title;

  DateTime getCreationDate() => _creationDate;

  DateTime getDate() => _displayDate;

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
        name: 'None',
        strength: 0,
        color: Colors.black); // This shouldn't happen
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
    );
  }
}
