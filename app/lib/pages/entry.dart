import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/helper/classes.dart';

import 'dart:math';

class JournalEntry {
  // unique id for each entry
  final int id = UniqueKey().hashCode;

  // Journal entry title and body
  String title = "";
  String entryText = "";
  String previewText = "";

  // year, month, day
  DateTime creationDate = DateTime.now();
  DateTime displayDate = DateTime(1970, 12, 31);
  late List<Tag> tags;
  late List<Emotion> emotions;

  static const previewLength = 35;

  // Plan
  late bool? completedStatus;
  dynamic pageRoute;

  JournalEntry({
    required this.title,
    required this.entryText,
    required this.creationDate,
    displayDate,
    tags,
    emotions,
    bool? planStatus,
  }) {
    this.tags = tags ?? [];
    this.emotions = emotions ?? [];
    this.displayDate = displayDate ?? creationDate;
    completedStatus = planStatus;

    final preview = entryText.split("\n").first;
    if (entryText.length >= previewLength) {
      previewText =
          "${preview.substring(0, min(previewLength, preview.length))}...";
    } else {
      previewText = preview;
    }

    pageRoute = (() => EntryPage.route(entry: this));
  }

  // Get the strongest emotion in the entry
  Emotion? getStrongestEmotion() {
    if (emotions.isNotEmpty) {
      Emotion strongestEmotion = emotions[0];
      for (int i = 1; i < emotions.length; i++) {
        (strongestEmotion.strength < emotions[i].strength)
            ? strongestEmotion = emotions[i]
            : 0;
      }
      return strongestEmotion;
    }
  }

  DisplayCard asDisplayCard() {
    return DisplayCard(
      page: pageRoute,
      entry: this,
    );
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
                  Text(widget.entry.title),
                ],
              ),
            ),

            // Tags
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(direction: Axis.horizontal, children: [
                for (var i in widget.entry.tags)
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
                  for (var i in widget.entry.emotions)
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
                  Text(widget.entry.entryText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
