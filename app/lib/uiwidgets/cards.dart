import 'dart:math';

import 'package:app/pages/entries.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';

import '../helper/classes.dart';

/// A card that displays text with a title and main text body
class DisplayCard extends StatefulWidget {
  final String title;
  final String body;
  final DateTime date;
  final List<Tag> tagList;
  final List<Emotion> emotionList;

  final dynamic page;

  const DisplayCard(
      {super.key,
      required this.title,
      required this.body,
      required this.date,
      this.page,
      required this.tagList,
      required this.emotionList});

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //The card should take the full width of the screen (with some padding)
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,

      //Uses gesture detector to enable interactivity
      child: GestureDetector(
        onTap: () {
          if (widget.page != null) {
            final route = widget.page!;
            Navigator.of(context).push(route());
          }
        },

        // Actual display card
        child: Card(
          // Rounded darker border
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),

          // Rounded background
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getCurrentTheme().colorScheme.background.withAlpha(200),
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: (() {
                    List<Color> bgCardColors = [];
                    if (widget.emotionList.isNotEmpty) {
                      if (widget.emotionList.length > 1) {
                        for (int i = 0;
                            i < min(widget.emotionList.length, 2);
                            i++) {
                          bgCardColors
                              .add(widget.emotionList[i].color.withAlpha(150));
                        }
                      } else {
                        bgCardColors
                            .add(widget.emotionList[0].color.withAlpha(150));
                        bgCardColors
                            .add(widget.emotionList[0].color.withAlpha(150));
                      }
                    } else if (widget.tagList.isNotEmpty) {
                      if (widget.tagList.length > 1) {
                        for (int i = 0;
                            i < min(widget.tagList.length, 2);
                            i++) {
                          bgCardColors
                              .add(widget.tagList[i].color.withAlpha(150));
                        }
                      } else {
                        bgCardColors
                            .add(widget.tagList[0].color.withAlpha(150));
                        bgCardColors
                            .add(widget.tagList[0].color.withAlpha(150));
                      }
                    } else {
                      bgCardColors.add(Colors.grey.shade800.withAlpha(150));
                      bgCardColors.add(Colors.grey.shade400.withAlpha(150));
                    }
                    return bgCardColors;
                  }())),
            ),

            // All information in the card held here
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    // Title
                    Text(
                      (widget.title.length > 35)
                          ? widget.title.substring(0, 35)
                          : widget.title,
                      style: DefaultTextStyle.of(context).style.apply(
                            fontSizeFactor: 1.3,
                            fontWeightDelta: 1,
                          ),
                    ),

                    // preview text
                    Text(
                      widget.body,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ]),

                  // Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Day
                      Text(
                        widget.date.day.toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const Padding(padding: EdgeInsets.only(left: 5)),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First 3 letters of the month
                            Text(
                              widget.date.formatDate().substring(0, 3),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            // Year
                            Text(
                              widget.date.year.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ])
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

mixin DisplayOnCard {
  ({
    String title,
    String body,
    DateTime date,
    List<Tag> tagList,
    List<Emotion> emotionList,
  }) card =
      (title: "", body: "", date: DateTime.now(), tagList: [], emotionList: []);
  dynamic pageRoute;

  DisplayCard asDisplayCard() {
    return DisplayCard(
      title: card.title,
      body: card.body,
      date: card.date,
      page: pageRoute,
      tagList: card.tagList,
      emotionList: card.emotionList,
    );
  }
}
