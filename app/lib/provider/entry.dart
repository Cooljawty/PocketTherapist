import 'package:app/pages/entries.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart' as settings;
import 'dart:math';

List<JournalEntry> entries = [];

//add tag list
List<Tag> tagList = [
  Tag(name: 'Calm', color: const Color(0xff90c6cf)),
  Tag(name: 'Centered', color: const Color(0xff794e5d)),
  Tag(name: 'Content', color: const Color(0xfff1903a)),
  Tag(name: 'Fulfilled', color: const Color(0xff59b1a1)),
  Tag(name: 'Patient', color: const Color(0xff00c5cb)),
  Tag(name: 'Peaceful', color: const Color(0xffa7d7d6)),
  Tag(name: 'Present', color: const Color(0xffff706f)),
  Tag(name: 'Relaxed', color: const Color(0xff3f6961)),
  Tag(name: 'Serene', color: const Color(0xffb7d2c4)),
  Tag(name: 'Trusting', color: const Color(0xff41aa8b)),
];

//Map<String, Tag> tags = {
// 'Calm': Tag(name: 'Calm', color: const Color(0xff90c6cf)),
// 'Centered': Tag(name: 'Centered', color: const Color(0xff794e5d)),
// 'Content': Tag(name: 'Content', color: const Color(0xfff1903a)),
// 'Fulfilled': Tag(name: 'Fulfilled', color: const Color(0xff59b1a1)),
// 'Patient': Tag(name: 'Patient', color: const Color(0xff00c5cb)),
// 'Peaceful': Tag(name: 'Peaceful', color: const Color(0xffa7d7d6)),
// 'Present': Tag(name: 'Present', color: const Color(0xffff706f)),
// 'Relaxed': Tag(name: 'Relaxed', color: const Color(0xff3f6961)),
// 'Serene': Tag(name: 'Serene', color: const Color(0xffb7d2c4)),
// 'Trusting': Tag(name: 'Trusting', color: const Color(0xff41aa8b)),
//};

//add emotion list
// List<Emotion> emotionList = [];
Map<String, Color> emotionList = {
  'Happy': const Color(0xfffddd67),
  'Trust': const Color(0xff308c7d),
  'Fear': const Color(0xff4c4e51),
  'Sad': const Color(0xff1f3550),
  'Disgust': const Color(0xff384e35),
  'Anger': const Color(0xffb51c1b),
  'Anticipation': const Color(0xffff7fff),
  'Surprise': const Color(0xFFFF8200),
};

//Map<String, Emotion> emotions = {
//  'Happy': Emotion(name: 'Happy', color: const Color(0xfffddd67)),
//  'Trust': Emotion(name: 'Trust', color: const Color(0xff308c7d)),
//  'Fear': Emotion(name: 'Fear', color: const Color(0xff4c4e51)),
//  'Sad': Emotion(name: 'Happy', color: const Color(0xff1f3550)),
//  'Disgust': Emotion(name: 'Happy', color: const Color(0xff384e35)),
//  'Anger': Emotion(name: 'Happy', color: const Color(0xffb51c1b)),
//  'Anticipation': Emotion(name: 'Happy', color: const Color(0xffff7fff)),
//  'Surprise': Emotion(name: 'Happy', color: const Color(0xFFFF8200)),
//
//};

void loadTagsEmotions() {
//load tags
  Object? foundTags = settings.getOtherSetting("tags");
  //if (foundTags != null && foundTags is Map<String, int>){
  //  tags.clear();
  //  foundTags.forEach((key, value) => tags[key] = Tag(name: key, color: Color(value)));
  //}
  if (foundTags !=null && foundTags is Map<String, int>){
    tagList.clear();
    for(final MapEntry<String, int>(:key, :value) in foundTags.entries){
      tagList.add(Tag(name: key, color: Color(value)));
    }
  }


  Object? foundEmotions = settings.getOtherSetting('emotions');
  if (foundEmotions != null && foundEmotions is Map<String, int>) {
    emotionList.clear();
    for(final MapEntry<String, int>(:key, :value) in foundEmotions.entries){
      emotionList[key] = Color(value);
    }
  }
  //if(foundEmotions != null && foundEmotions is Map<String, int>){
  //  foundEmotions.forEach((key, value) {
  //    if(emotions.containsKey(key)){
  //      emotions[key] = Emotion(name:key, color: Color(value));
  //    }
  //  });
  //}
}

void saveTagsEmotions() {
  Map<String, int> map = {};
  //tags.forEach((key, value) => map[key] = value.color.value);
  for(final Tag element in tagList) {
    map[element.name] = element.color.value;
  }
  settings.setOtherSetting('tags', Map<String, int>.of(map));
  map.clear();
  //emotions.forEach((key, value) => map[key] = value.color.value);
  settings.setOtherSetting('emotions', map);
}

//void reset() {
//  emotions = {
//    'Happy': Emotion(name: 'Happy', color: const Color(0xfffddd67)),
//    'Trust': Emotion(name: 'Trust', color: const Color(0xff308c7d)),
//    'Fear': Emotion(name: 'Fear', color: const Color(0xff4c4e51)),
//    'Sad': Emotion(name: 'Happy', color: const Color(0xff1f3550)),
//    'Disgust': Emotion(name: 'Happy', color: const Color(0xff384e35)),
//    'Anger': Emotion(name: 'Happy', color: const Color(0xffb51c1b)),
//    'Anticipation': Emotion(name: 'Happy', color: const Color(0xffff7fff)),
//    'Surprise': Emotion(name: 'Happy', color: const Color(0xFFFF8200)),
//  };
//
//  tags = {
//   'Calm': Tag(name: 'Calm', color: const Color(0xff90c6cf)),
//   'Centered': Tag(name: 'Centered', color: const Color(0xff794e5d)),
//   'Content': Tag(name: 'Content', color: const Color(0xfff1903a)),
//   'Fulfilled': Tag(name: 'Fulfilled', color: const Color(0xff59b1a1)),
//   'Patient': Tag(name: 'Patient', color: const Color(0xff00c5cb)),
//   'Peaceful': Tag(name: 'Peaceful', color: const Color(0xffa7d7d6)),
//   'Present': Tag(name: 'Present', color: const Color(0xffff706f)),
//   'Relaxed': Tag(name: 'Relaxed', color: const Color(0xff3f6961)),
//   'Serene': Tag(name: 'Serene', color: const Color(0xffb7d2c4)),
//   'Trusting': Tag(name: 'Trusting', color: const Color(0xff41aa8b)),
//  };
//}

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
class Emotion {
  final String name;
  Color color;
  int strength = 0;

  Emotion({
    required this.name,
    this.strength = 0,
    required this.color,
  });
}

class JournalEntry implements Comparable<JournalEntry>{
  // unique id for each entry
  final int id = UniqueKey().hashCode;

  // Journal entry title and body
  String title = "";
  String entryText = "";
  String previewText = "";

  // year, month, day
  DateTime creationDate = DateTime.now();
  DateTime date = DateTime(1970, 12, 31);
  List<Tag> tags = [];
  List<Emotion> emotions = [];

  static const previewLength = 25;

  // Plans
  bool? planCompleted;

  JournalEntry({
    required this.title,
    required this.entryText,
    required this.date,
    this.tags = const [],
    this.emotions = const [],
    this.planCompleted,
  }) {
    previewText = entryText.substring(0, min(previewLength, entryText.length));
  }

  void update([
    String? newTitle,
    String? newEntryText,
    List<Tag>? newTags,
    List<Emotion>? newEmotions,
  ]) {
    if(newTitle != null) title = newTitle;
    if(newEntryText != null) {
      entryText = newEntryText;
      previewText = previewText.substring(0, min(previewLength, entryText.length));
    }
    if(newTags != null) tags = newTags;
    if(newEmotions != null) emotions = newEmotions;
  }

  List<Color> getGradientColors() {
    List<Color> colors = [];
    if (emotions.length >= 2){
      emotions.sort((e1, e2) => e1.strength > e2.strength ? 1 : 0);
      colors.add(emotions[0].color);
      colors.add(emotions[1].color);
    } else if (emotions.isNotEmpty) {
      colors.add(emotions[0].color);
      colors.add(Colors.white24);
    } else if (tags.length >= 2) {
      colors.add(tags[0].color);
      colors.add(tags[1].color);
    } else if (tags.isNotEmpty){
      colors.add(tags[0].color);
      colors.add(Colors.white24);
    } else {
      colors.add(Colors.black12);
      colors.add(Colors.white24);
    }
    return colors;
  }


  // Get the strongest emotion in the entry
  Emotion getStrongestEmotion() {
    if (emotions.isNotEmpty) {
      Emotion strongestEmotion = emotions[0];
      for (int i = 1; i < emotions.length; i++) {
        (strongestEmotion.strength < emotions[i].strength)
            ? strongestEmotion = emotions[i]
            : 0;
      }
      return strongestEmotion;
    }
    return Emotion(name: 'None', strength: 0, color: Colors.black); // This shouldn't happen
  }

  /* TODO
	List<Image> pictures;
	List<Image> getPictures();
	*/

  /// If this [JournalEntry] has the same [earliestDate] as [other]
  /// we will compare them based on the [title]
  @override
  int compareTo(JournalEntry other) {
    int order = other.date.compareTo(date) ;
    return order == 0 ? other.title.compareTo(title) : order;
  }
}

Future<void> makeNewEntry(BuildContext context) async {
  final JournalEntry? result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EntryPage()));
  if (result is JournalEntry) {
    entries.add(result);
  }
}
