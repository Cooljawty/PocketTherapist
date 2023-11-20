import 'dart:math';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:starsview/starsview.dart';
import 'package:app/provider/theme_settings.dart';

import '../provider/theme_settings.dart';

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
                        size: 50,
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
                        size: 50,
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
        alignment: Alignment.bottomLeft, //changing the origin
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
        alignment: Alignment.bottomLeft, //changing the origin
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

///
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
        StarsView(
          fps: 60,
        )
      ],
    );
  }
}

// class LoadingAnimation extends StatefulWidget {
//   const LoadingAnimation({
//     super.key
//   });
//
//   @override
//   State<LoadingAnimation> createState() => _LoadingAnimationState();
// }
//
// class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//  final frames = [Image.asset('assets/frame1.png'),
//    Image.asset('assets/frame2.png'),
//    Image.asset('assets/frame3.png'),
//    Image.asset('assets/frame4.png')];
//  final words = ["Loading.", "Loading..", "Loading..." "Loading...."];
//
//  @override
//  void initState() {
//    super.initState();
//    _animationController = AnimationController(
//      vsync: this,
//      duration: const Duration(milliseconds: 1000),
//      lowerBound: 0,
//      upperBound: 2.0
//    )..repeat();
//  }
//
//  @override
//  void dispose() {
//    _animationController.dispose();
//    super.dispose();
//  }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           backgroundColor: const Color.fromRGBO(0, 0 , 0, 75),
//           body: Center(
//             child: SizedBox(
//               width: 100,
//               height: 100,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: AnimatedBuilder(
//                       animation: _animationController,
//                       builder: (context, child) => Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Visibility(
//                             visible: _animationController.value <= 0.5,
//                             child: LoadingIcon(img: frames[0], txt: words[0])
//                           ),
//                           Visibility(
//                               visible: 0.5 < _animationController.value  && _animationController.value <= 1,
//                               child: LoadingIcon(img: frames[1], txt: words[1])
//                           ),
//                           Visibility(
//                               visible: 1 < _animationController.value && _animationController.value <= 1.5,
//                               child: LoadingIcon(img: frames[2], txt: words[2])
//                           ),
//                           Visibility(
//                               visible: 1.5 < _animationController.value && _animationController.value <= 2.0,
//                               child: LoadingIcon(img: frames[3], txt: words[3])
//                           )
//                         ],
//                       )
//
//                     )
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//   }
// }
//
// class LoadingIcon extends StatelessWidget {
//   final Image img;
//   final String txt;
//   const LoadingIcon({
//     super.key,
//     required this.img,
//     required this.txt
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(padding: const EdgeInsets.all(8), child: img),
//          Text(txt)
//       ],
//     );
//   }
// }

//class LoadingAnimation extends StatefulWidget {
//  const LoadingAnimation({super.key});
//
//  @override
//  State<LoadingAnimation> createState() => _LoadingAnimationState();
//}
//
//class _LoadingAnimationState extends State<LoadingAnimation> {
//  late final Timer timer;
//  final frames = [Image.asset('assets/frame1.png'),
//    Image.asset('assets/frame2.png'),
//    Image.asset('assets/frame3.png'),
//    Image.asset('assets/frame4.png')];
//  int _index = 0;
//
//  @override
//  void initState() {
//    super.initState();
//    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//      setState(() => (_index = (_index++ % 3)));
//    });
//  }
//  @override
//  void dispose() {
//    timer.cancel();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Stack(
//        children: [
//          PageView.builder(itemBuilder: (context, index) {
//            return Stack (
//              children: [
//                Column(
//                  children: [
//                    Center(
//                      child: Container(
//                        decoration: const BoxDecoration(color: Colors.white),
//                        child: frames[index]
//                      )
//                  ),
//            ]
//                ),
//              ],
//            );
//          },)
//        ]
//      ),
//    );
//  }
//}
