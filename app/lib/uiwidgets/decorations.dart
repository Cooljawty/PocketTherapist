import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';


class Quote extends StatefulWidget {
  String? currentQuote;
  static YamlList? quotes;
  Quote({super.key});

  void newQuote(){
    Random rand = Random();
    currentQuote = quotes![rand.nextInt(quotes!.length)];
  }

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {

  @override
  void initState() {
    super.initState();
    if(Quote.quotes == null) throw StateError("Quotes were not properly initialized. Cannot continue.");
    widget.newQuote();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 350,
        height: 240,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Quote of the Day:",
              textAlign: TextAlign.left,
            ),
            //extra container to hold the qoute
            Container(
              width: 310,
              height: 150,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 3.0,
                  ),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(15.0))),
              //now we only need a text widget for qoute
              child: Text(
                //qoute from app
                widget.currentQuote ?? "empty",
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(onPressed: () {
                setState(widget.newQuote);
              }, child: const Text("New Quote")),
          ],
        ),
      );
  }
}

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
