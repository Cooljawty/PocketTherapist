/// Tags
///
class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  int get getId{return id;}
  String get getName{return name;}
}

/// Emotions
///
class Emotion {
  final int id;
  final String name;
  int strength = 0;

  Emotion({
    required this.id,
    required this.name,
  });


  int get getId{return id;}
  String get getName{return name;}
  void setStrength(int val) {strength = val;}
}
