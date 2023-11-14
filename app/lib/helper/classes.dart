import 'package:flutter/material.dart';

/// Tags
///
class Tag {
  final String name;
  Color color;

  Tag({
    required this.name,
    this.color = Colors.blue
  });
}

/// Emotions
///
class Emotion extends Tag {
  int strength = 0;

  Emotion({
    required super.name,
    this.strength = 0,
  });
}
