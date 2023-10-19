import 'package:flutter/material.dart';

class RandomQuoteGenerator extends StatefulWidget {
  const RandomQuoteGenerator({super.key});


  @override
  State<RandomQuoteGenerator> createState() => _RandomQuoteGeneratorState();
}

class _RandomQuoteGeneratorState extends State<RandomQuoteGenerator> {
  late String currentQuote;


  void newQuote(){
    setState(() {
      currentQuote = ;
    });
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
            const Align(
                alignment: Alignment.topLeft,
                widthFactor: 2,
                child: Text(
                  "Quote of the Day:",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )),
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
                currentQuote,
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(onPressed: newQuote, child: const Text("New Quote")),
          ],
        ),
      );
  }
}

