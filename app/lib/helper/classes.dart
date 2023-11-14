import 'package:flutter/material.dart';

/// Tags
///
class Tag {
  final String name;
  Color color;

  Tag({required this.name, this.color = Colors.blue});

  String getName() => name;
  Color getColor() => color;
}

/// Emotions
///
class Emotion extends Tag {
  final String name;
  int strength = 0;

  Emotion({
    required this.name,
  }) : super(name: name);


  void setStrength(int val) {strength = val;}
}
