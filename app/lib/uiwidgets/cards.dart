import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';

/// A card that displays text with a title and main text bocy
class DisplayCard extends StatefulWidget {
  final String title;
  final String body;
  final DateTime date;

  final Route<dynamic>? page;

  const DisplayCard(
      {super.key,
      required this.title,
      required this.body,
      required this.date,
      this.page});

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
            Navigator.of(context).push(route);
          }
        },
        child: Card(
            color: getCurrentTheme().colorScheme.background,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: getCurrentTheme().colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),


            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        widget.title,
                        style: DefaultTextStyle.of(context).style.apply(
                              fontSizeFactor: 1.3,
                              fontWeightDelta: 1,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        widget.body,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ]),
              const Spacer(),

              Container(
                padding: const EdgeInsets.all(2),
                child: Text(
                  '${widget.date.month.toString()}/${widget.date.day.toString()}/${widget.date.year.toString()}',
                ),
              ),
            ])),
      ),
    );
  }
}

mixin DisplayOnCard {
  ({String title, String body, DateTime date}) card =
      (title: "", body: "", date: DateTime.now());

  Route<dynamic>? pageRoute;

  DisplayCard asDisplayCard() {
    return DisplayCard(
        title: card.title, body: card.body, date: card.date, page: pageRoute);
  }
}
