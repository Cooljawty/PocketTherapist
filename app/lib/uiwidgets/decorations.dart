import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'dart:math';

class QuoteContainer extends StatefulWidget {
  final List<String> _quotes;
  QuoteContainer({super.key}) {
    _loadQuotes();
  };

  List<String> _loadQuotes() async {
    String quoteFileContent = await rootBundle.loadString('assets/quotes.yml');
    var quoteYamlList = loadYaml(quoteFileContent);

  }


  @override
  State<QuoteContainer> createState() => _QuoteContainerState();
}

class _QuoteContainerState extends State<QuoteContainer> {

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
            
            TextButton(onPressed: () {
              setState(() {
                widget._newQuote();
              });
            }, child: const Text("New Quote")),
          ],
        ),
      );
  }
}

class Quote extends StatefulWidget {
  final String quote;
  const Quote({super.key, required this.quote});

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        widget.quote,
        textAlign: TextAlign.center,
      ),
    );
  }
}
