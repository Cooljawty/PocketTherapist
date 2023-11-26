import 'dart:math';

import 'package:app/pages/entries.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';


import '../pages/entry.dart';

/// A card that displays an entry with a title and main text body
class DisplayCard extends StatefulWidget {
  final JournalEntry entry;
  final dynamic page;

  const DisplayCard({
    super.key,
    this.page,
    required this.entry,
  });

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
                    if (widget.entry.emotions.isNotEmpty) {
                      if (widget.entry.emotions.length > 1) {
                        for (int i = 0;
                            i < min(widget.entry.emotions.length, 2);
                            i++) {
                          bgCardColors.add(
                              widget.entry.emotions[i].color.withAlpha(150));
                        }
                      } else {
                        bgCardColors
                            .add(widget.entry.emotions[0].color.withAlpha(150));
                        bgCardColors
                            .add(widget.entry.emotions[0].color.withAlpha(150));
                      }
                    } else if (widget.entry.tags.isNotEmpty) {
                      if (widget.entry.tags.length > 1) {
                        for (int i = 0;
                            i < min(widget.entry.tags.length, 2);
                            i++) {
                          bgCardColors
                              .add(widget.entry.tags[i].color.withAlpha(150));
                        }
                      } else {
                        bgCardColors
                            .add(widget.entry.tags[0].color.withAlpha(150));
                        bgCardColors
                            .add(widget.entry.tags[0].color.withAlpha(150));
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title
                        Text(
                          (widget.entry.title.length > 30)
                              ? '${widget.entry.title.substring(0, 30)}...'
                              : widget.entry.title,
                          style: widget.entry.completedStatus == true
                              // If plan is finished, show a strikethrough
                              ? DefaultTextStyle.of(context).style.apply(
                                    fontSizeFactor: 1.3,
                                    fontWeightDelta: 1,
                                    decoration: TextDecoration.lineThrough,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationColor: Colors.orange,
                                    // decorationThicknessFactor: 1.3,
                                    // decorationThicknessDelta: 1,
                                  )
                              // Otherwise no text style changes
                              : DefaultTextStyle.of(context).style.apply(
                                    fontSizeFactor: 1.3,
                                    fontWeightDelta: 1,
                                  ),
                        ),

                        // preview text
                        Text(
                          widget.entry.previewText,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ]),

                  // Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // If not a plan, display no checkbox
                      widget.entry.completedStatus == null
                          ? Container()
                          : IconButton(
                              key: const Key("PlanCompleteButton"),
                              // Show filled outline for completed
                              icon: const Icon(Icons.check_box_outline_blank),
                              selectedIcon: const Icon(Icons.check_box),
                              isSelected: widget.entry.completedStatus == true,
                              onPressed: (() {
                                setState(() {
                                  // Toggle plan completion status on press
                                  if (widget.entry.completedStatus != null) {
                                    widget.entry.completedStatus =
                                        !widget.entry.completedStatus!;
                                  }
                                });
                              })),
                      // Day
                      Text(
                        widget.entry.displayDate.day.toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const Padding(padding: EdgeInsets.only(left: 5)),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First 3 letters of the month
                            Text(
                              widget.entry.displayDate
                                  .formatDate()
                                  .substring(0, 3),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            // Year
                            Text(
                              widget.entry.displayDate.year.toString(),
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

// DisplayOnCard causes stack overflow with an entry when using
// an actual entry, logic moved to Entry instead.
// mixin DisplayOnCard {
//   ({
//     JournalEntry entry,
//   }) card = (
//     entry: JournalEntry(title: "",
//         entryText: "",
//         date: DateTime.now())
//   );
//   dynamic pageRoute;
//
//   DisplayCard asDisplayCard() {
//     return DisplayCard(
//       page: pageRoute,
//       entry: card.entry,
//     );
//   }
// }
