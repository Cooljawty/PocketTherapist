import 'package:flutter/material.dart';

/// Tags
///
class Tag {
  final String name;
  Color color;

  Tag({
    required this.name,
    required this.color,
  });
}

/// Emotions
///
class Emotion extends Tag {
  int strength = 0;

  Emotion({
    required super.name,
    this.strength = 0,
    required super.color,
  });
}

/// Graph Types
/// An enum for each graph type an [EmotionGraph] can be displayed as
enum GraphTypes{ 
	time, frequency;
	
	String toString() => this.name.split('.').last; 
}

