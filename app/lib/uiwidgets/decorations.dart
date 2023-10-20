import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'dart:math';

class RandomQuoteGenerator extends StatefulWidget {
  //final String _quoteFilePath;
  late final List<String> _quotes = [];
  RandomQuoteGenerator({super.key}){
    _loadQuotes();
  }

  void _loadQuotes() async {
    var settingsFile =
    String contents = await settingsFile.readAsString();
    var contentAsYml = loadYaml(contents);
    _quotes.addAll(contentAsYml['Quotes']);
  }

  String _newQuote(){
    var random = Random();
    debugPrint('$_quotes.length');
    int quoteIndex = random.nextInt(_quotes.length);
    debugPrint('$quoteIndex');
    return _quotes[quoteIndex];
  }

  @override
  State<RandomQuoteGenerator> createState() => _RandomQuoteGeneratorState();
}

class _RandomQuoteGeneratorState extends State<RandomQuoteGenerator> {
  late String _currentQuote;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentQuote = widget._quotes[Random().nextInt(widget._quotes.length)];
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
                _currentQuote,
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(onPressed: () => _currentQuote = widget._newQuote(), child: const Text("New Quote")),
          ],
        ),
      );
  }
}

