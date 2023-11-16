// import 'dart:developer';
import 'dart:math';

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
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: getCurrentTheme().colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: ((){
                    List<Color> bgCardColors = [];
                    if(widget.emotionList.isNotEmpty){
                      if(widget.emotionList.length > 1){
                        for (int i = 0; i < min(widget.emotionList.length, 3); i++) {
                          bgCardColors.add(widget.emotionList[i].color);
                        }
                      }else{
                        bgCardColors.add(widget.emotionList[0].color);
                        bgCardColors.add(widget.emotionList[0].color);
                      }
                    }else if(widget.tagList.isNotEmpty){
                      if(widget.tagList.length > 1){
                        for (int i = 0; i < min(widget.tagList.length, 3); i++) {
                          bgCardColors.add(widget.tagList[i].color);
                        }
                      }else{
                        bgCardColors.add(widget.tagList[0].color);
                        bgCardColors.add(widget.tagList[0].color);
                      }
                    }else{
                      bgCardColors.add(Colors.grey.shade800);
                      bgCardColors.add(Colors.grey.shade400);
                    }
                    return bgCardColors;
                  }())
              ),
            ),

            child: Row( // row to hold all information
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Column( // Column to hold title and preview text
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Title
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.title,
                          style: DefaultTextStyle.of(context).style.apply(
                            fontSizeFactor: 1.3,
                            fontWeightDelta: 1,
                          ),
                        ),
                      ),
                      // preview text
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.body,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]),
                // spacer to push the date to the right and the text to the left
                const Spacer(),

                // Date
                Container(
                  padding: const EdgeInsets.all(7),
                  child: Text(
                    '${widget.date.month.toString()}/${widget.date.day.toString()}/${widget.date.year.toString()}',
                  ),
                ),
              ]),
          ),
        ),
      ),
    );
  }
}

mixin DisplayOnCard {
  ({String title, String body, DateTime date, List<Tag> tagList, List<Emotion> emotionList,})card = (title: "", body: "", date: DateTime.now(), tagList: [], emotionList: []);
  dynamic pageRoute;

  DisplayCard asDisplayCard() {
    return DisplayCard(
        title: card.title, body: card.body, date: card.date, page: pageRoute, tagList: card.tagList, emotionList: card.emotionList,);
  }
}
