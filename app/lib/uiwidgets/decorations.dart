import 'dart:math';

import 'package:flutter/material.dart';
List<String> quotes = [
  "Is God willing to prevent evil, but not able? Then he is not omnipotent. Is he able, but not willing? Then he is Malevolent. Is he both able and willing? Then whence cometh evil? Is he neither able nor willing? Then why call him God?",
  "I have love in me the likes of which you can scarcely imagine and rage the likes of which you would not believe. If I cannot satisfy the one, I will indulge the other.",
  "There is no good or evil, just men trying to control the world.",
];

class Quote extends StatefulWidget {
  final Random rand = Random();
  Quote({super.key});

  String newQuote(){
    return quotes[rand.nextInt(quotes.length)];
  }

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  late String currentQuote;

  @override
  void initState() {
    super.initState();
    currentQuote = widget.newQuote();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 350,
        height: 225,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                widthFactor: 2,
                child: Text(
                  "Quote of the Day:",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            //extra container to hold the quote
            Container(
              width: 310,
              height: 150,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border.all(
                    //left for now
                    color: Colors.black,
                    width: 3.0,
                  ),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(15.0))),

              //now we only need a text widget for quote
              child: Text(
                // quote from app
                currentQuote,
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(onPressed: () {
              setState(() => currentQuote = widget.newQuote());
              }, child: Text("New Quote", style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
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