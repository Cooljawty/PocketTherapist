import 'dart:math';
import 'package:app/pages/entries.dart';
import 'package:app/provider/entry.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:starsview/starsview.dart';
import 'package:app/provider/theme_settings.dart';

List<String> quotes = [
  "Is God willing to prevent evil, but not able? Then he is not omnipotent. Is he able, but not willing? Then he is Malevolent. Is he both able and willing? Then whence cometh evil? Is he neither able nor willing? Then why call him God?",
  "I have love in me the likes of which you can scarcely imagine and rage the likes of which you would not believe. If I cannot satisfy the one, I will indulge the other.",
  "There is no good or evil, just men trying to control the world.",
  "The mind is not a vessel to be filled but a fire to be kindled.\n- Plutarch",
  "The miserable have no other medicine but only hope.\n- William Shakespeare",
  "Man is the cruelest animal.\n- Friedrich Nietzsche",
  "Whatever you are, be a good one.\n- Abraham Lincoln",
  "Falling down is not a failure. Failure comes when you stay where you have fallen.\n- Socrates",
  "The only true possession you have is your own self.\n- Socrates",
  "I cannot teach anybody anything. I can only make them think.\n- Socrates",
  "A system of morality which is based on relative emotional values is a mere illusion, a thoroughly vulgar conception which has nothing sound in it and nothing true.\n- Socrates",
  "If life were predictable it would cease to be life and be without flavor.\n-Eleanor Roosevelt",
  "Darkness cannot drive out darkness: only light can do that. Hate cannot drive out hate: only love can do that.\n- Martin Luther King Jr.",
  "The way to get started is to quit talking and begin doing.\n- Walt Disney",
  "It does not matter how slowly you go as long as you do not stop.\n- Confucius",
  "Reading maketh a full man; conference a ready man; and writing an exact man.\n- Francis Bacon",
  "Only one man ever understood me, and he didn't understand me\n- G.W.F. Hegel",
];

// For display quotes
String currentQuote = "";
String nextQuote = "";

class Quote extends StatefulWidget {
  final Random rand = Random();
  Quote({super.key});

  String newQuote() {
    return quotes[rand.nextInt(quotes.length)];
  }

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> with TickerProviderStateMixin {
  // For quote fade in and out animations
  bool clicked = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    currentQuote = widget.newQuote();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key("Quote"),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(
                width: 4,
                color: Theme.of(context).colorScheme.primaryContainer,
              )),
        ),
        //height: 210,
        width: MediaQuery.of(context).size.width,

        // animate the quote fade in and out
        child: AnimatedOpacity(
          onEnd: (() {
            setState(() {
              // To play the animation twice
              visible = true;
              clicked = false;

              // Update quote here so it doesn't change before fade out and after fade in
              currentQuote = nextQuote;
            });
          }),

          // If not clicked and is visible, then play fading in animation
          // Otherwise fade out
          opacity: (clicked == false && visible == true) ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Top Quotation
                Transform.flip(
                    origin: const Offset(-40, 0),
                    flipX: true,
                    child: Icon(Icons.format_quote_rounded,
                        size: 40,
                        color: getCurrentTheme().colorScheme.primaryContainer)),

                // Quote
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    // quote from app
                    currentQuote,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // Bottom Quotation
                Transform(
                    transform: Matrix4.translationValues(80, 0, 0),
                    child: Icon(Icons.format_quote_rounded,
                        size: 40,
                        color: getCurrentTheme().colorScheme.primaryContainer)),
              ]),
        ),
        // ),
      ),
      onTap: () {
        // When tapping on the quote container, make the quote fade out and prepare the next quote
        setState(() {
          clicked = true;
          visible = !clicked;
          nextQuote = widget.newQuote();
        });
      },
    );
  }
}

/// Stripe background for reuse
class StripeBackground extends StatelessWidget {
  const StripeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Stripe
      Transform(
        transform: Matrix4.skewY(-0.45),
        origin: const Offset(60, 0),
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            color: darkenColor(getCurrentTheme().colorScheme.secondary, .05),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),

      // Top primary color
      Transform(
        transform: Matrix4.skewY(-0.45),
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            color: getCurrentTheme().colorScheme.primary,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    ]);
  }
}

/// Background for Entries and Plans Currently
class StarBackground extends StatelessWidget {
  const StarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            getCurrentTheme().colorScheme.primary,
            getCurrentTheme().colorScheme.background,
          ],
        ))),
        const StarsView(
          fps: 60,
        )
      ],
    );
  }
}

/// [CustomNavigationBar] - The Navigator at the bottom of the screen
/// [destinations] is the list of destinations that this navigationbar should be able to reach
/// [selectedIndex] is the starting index that we will display, by default its 0
/// [onDestinationSelected] is the void Function(int) that should handle the routing of the navgations
/// ignore: prefer_const_constructors_in_immutables
class CustomNavigationBar extends StatelessWidget{

  static const List<NavigationDestination> defaultDestinations = [
            NavigationDestination(icon: Icon(Icons.dashboard), label: "Dashboard"),
            NavigationDestination(icon: Icon(Icons.feed), label: "Entries"),
            NavigationDestination(icon: Icon(Icons.add), label: "NewEntry"),
            NavigationDestination(icon: Icon(Icons.calendar_month), label: "Calendar"),
            NavigationDestination(icon: Icon(Icons.event_note), label: "Plans"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ];

  final List<NavigationDestination> destinations;
  int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  CustomNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.destinations = defaultDestinations,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: destinations,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if(index == selectedIndex) return;
        if(index >= destinations.length) return;
        onDestinationSelected == null ? defaultOnDestinationSelected(index, context) : onDestinationSelected!(index);
        selectedIndex = index;
      },
    );
  }

  void defaultOnDestinationSelected(int index, BuildContext context) async {
    switch(index) {
      case 2: makeNewEntry(context); return;
      case 5: Navigator.of(context).pushNamed(destinations[index].label); return;
      case _: Navigator.of(context).pushReplacementNamed(destinations[index].label); break;
    }
  }

}

/// A card that displays text with a title and main text body
class DisplayCard extends StatefulWidget {
  final JournalEntry entry;

  const DisplayCard({
    super.key,
    required this.entry
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExistingEntryPage(entry: widget.entry),));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: getCurrentTheme().colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Container(
            //width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: ((){
                    List<Color> bgCardColors = [];
                    if(widget.entry.emotions.isNotEmpty){
                      if(widget.entry.emotions.length > 1){
                        for (int i = 0; i < min(widget.entry.emotions.length, 3); i++) {
                          bgCardColors.add(widget.entry.emotions[i].color);
                        }
                      }else{
                        bgCardColors.add(widget.entry.emotions[0].color);
                        bgCardColors.add(widget.entry.emotions[0].color);
                      }
                    }else if(widget.entry.tags.isNotEmpty){
                      if(widget.entry.tags.length > 1){
                        for (int i = 0; i < min(widget.entry.tags.length, 3); i++) {
                          bgCardColors.add(widget.entry.tags[i].color);
                        }
                      }else{
                        bgCardColors.add(widget.entry.tags[0].color);
                        bgCardColors.add(widget.entry.tags[0].color);
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Title
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5,),
                              child: Text(
                                widget.entry.title,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.3,
                                  fontWeightDelta: 1,
                                ),
                              ),
                            )
                        ),

                        // preview text
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          // height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
                            child: Text(
                              widget.entry.previewText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),),
                        ),
                      ]
                  ),
                  // spacer to push the date to the right and the text to the left
                  const Spacer(),

                  // Date
                  Container(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      '${widget.entry.date.month.toString()}/${widget.entry.date.day.toString()}/${widget.entry.date.year.toString()}',
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
