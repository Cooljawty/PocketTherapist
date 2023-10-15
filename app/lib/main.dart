import 'package:app/settingsButton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// My app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const SettingsButton(),
        title: 'Welcome Screen',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        )
    );
  }
}
