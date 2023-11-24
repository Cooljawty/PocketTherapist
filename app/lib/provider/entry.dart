import 'package:app/pages/new_entry.dart';
import 'package:flutter/material.dart';
import 'package:app/provider/settings.dart' as settings;
import 'dart:math';

List<JournalEntry> entries = [
  // JournalEntry(
  //     title: "Location: Paris, France",
  //     entryText:
  //         'Today was my first day in Paris and it was absolutely magical. I woke up early and headed straight to the '
  //         'Eiffel Tower to catch the sunrise. The view from the top was breathtaking, with the sun just peeking over the horizon '
  //         'and casting a warm glow over the city.',
  //     date: DateTime(2022, 7, 12),
  //     tags: [
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Present', color: const Color(0xffff7070)),
  //       Tag(name: 'Content', color: const Color(0xfff1903b)),
  //       Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 90),
  //       Emotion(name: 'Anger', color: const Color(0xffb51c1c), strength: 70),
  //     ]),
  //
  // JournalEntry(
  //     title: "What are my core values and how do they impact my decisions?",
  //     entryText:
  //         'Today I’ve been considering my core values and how they impact the decisions I make in my life. I realize '
  //         'that my values are an essential part of who I am, and they play a significant role in shaping my thoughts, actions, '
  //         'and choices.',
  //     date: DateTime(2023, 1, 15),
  //     tags: [
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 40),
  //       Emotion(name: 'Trust', color: const Color(0xff308c7e), strength: 70),
  //     ]),
  //
  // JournalEntry(
  //     title: "Today was a good day",
  //     entryText:
  //         'Today was a busy day at work. I had a lot of meetings and deadlines to meet, which kept me on my toes all day. '
  //         'I felt a little bit stressed at times, but overall, I was able to stay focused and get everything done that needed to '
  //         'be done.',
  //     date: DateTime(2023, 4, 27),
  //     tags: [
  //       Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
  //       Tag(name: 'Patient', color: const Color(0xff00c5cc)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Happy', color: const Color(0xfffddd68), strength: 80),
  //       Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 10),
  //       Emotion(name: 'Trust', color: const Color(0xff308c7e), strength: 10),
  //     ]),
  //
  // JournalEntry(
  //     title: '“If not now, when?”',
  //     entryText:
  //         'Today, I decided to experiment with some mixed media art in my art journal. I started'
  //         ' by collaging some old book pages onto the page, creating a textured background. Then, I used watercolors to paint over the top,'
  //         ' blending different colors and creating a dreamy, abstract effect.',
  //     date: DateTime(2022, 5, 12),
  //     tags: [
  //       Tag(name: 'Present', color: const Color(0xffff7070)),
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //     ]),
  //
  // JournalEntry(
  //     title: "Mood",
  //     entryText:
  //         'I was late for work because of heavy traffic, and as soon as I walked into the office, my manager confronted me about '
  //         'being late',
  //     date: DateTime(2022, 8, 18),
  //     emotions: [
  //       //Emotion(name: 'Anticipation', color: const Color(0xffff8000), strength: 60),
  //       Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 10),
  //       Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 60),
  //     ]),
  //
  // // JournalEntry(
  // //     title: "Complete a 10k race in under an hour by the end of the year.",
  // //     entryText: 'I want to complete a 10k race in under an hour by the end of the year because I want to challenge myself, push my limits,'
  // //         ' and achieve something I’ve never done before.',
  // //     date: DateTime(2022, 9, 14),
  // //     emotions: [
  // //       Emotion(name: 'Sad', color: const Color(0xff1f3551), strength: 100),
  // //       Emotion(name: 'Anger', color: const Color(0xffb51c1c), strength: 100),
  // //     ]
  // // ),
  //
  // JournalEntry(
  //     title: "I am grateful for this moment of mindfulness",
  //     entryText:
  //         'Today, I took a few minutes to practice mindfulness during my lunch break. I closed my eyes and took a few deep breaths, '
  //         'feeling the air fill my lungs and then releasing it slowly.',
  //     date: DateTime(2022, 10, 21),
  //     tags: [
  //       Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
  //       Tag(name: 'Present', color: const Color(0xffff7070)),
  //       Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
  //       Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
  //       Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Centered', color: const Color(0xff794e5e)),
  //       Tag(name: 'Content', color: const Color(0xfff1903b)),
  //       Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
  //       Tag(name: 'Patient', color: const Color(0xff00c5cc)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Trust', color: const Color(0xff308c7e), strength: 100),
  //     ]),
  //
  // JournalEntry(
  //     title: "Extraordinary beauty of nature",
  //     entryText:
  //         'Today, I went for a hike at the nearby nature reserve and was struck by the abundance of wildflowers in bloom. As I walked '
  //         'along the trail, I noticed a field of vibrant blue, white, and red poppies swaying gently in the breeze.',
  //     date: DateTime(2023, 5, 17),
  //     tags: [
  //       Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
  //       Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
  //       Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Centered', color: const Color(0xff794e5e)),
  //       Tag(name: 'Content', color: const Color(0xfff1903b)),
  //       Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
  //     ],
  //     emotions: [
  //       Emotion(name: 'Fear', color: const Color(0xff4c4e52), strength: 50),
  //       Emotion(name: 'Trust', color: const Color(0xff308c7e), strength: 100),
  //     ]),
  //
  // JournalEntry(
  //     title: "Flying Over the Ocean",
  //     entryText:
  //         'Last night, I dreamed I was flying over the ocean, soaring through the sky with my arms outstretched. The sun was shining '
  //         'bright and the sky was a brilliant shade of blue. ',
  //     date: DateTime(2022, 9, 12),
  //     tags: [
  //       Tag(name: 'Calm', color: const Color(0xff90c6d0)),
  //       Tag(name: 'Centered', color: const Color(0xff794e5e)),
  //       Tag(name: 'Content', color: const Color(0xfff1903b)),
  //       Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
  //       Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
  //       Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
  //       Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  //     ],
  //     emotions: [
  //       Emotion(
  //           name: 'Anticipation', color: const Color(0xffff8000), strength: 50),
  //       Emotion(name: 'Anger', color: const Color(0xffb51c1c), strength: 50),
  //     ]),
];

//Generated list of journal entries
final items = entries;

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
  DateTime current = DateTime.now();
  DateTime date = DateTime(1970, 12, 31);
  List<Tag> tags = [];
  List<Emotion> emotions = [];

  static const previewLength = 25;

  JournalEntry({
    required this.title,
    required this.entryText,
    required this.date,
    this.tags = const [],
    this.emotions = const []
  }) {
    previewText = previewText.substring(0, min(previewLength, previewText.length));
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
    return Emotion(
        name: 'None', strength: 0, color: Colors.black); // This shouldn't happen
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

void makeNewEntry(BuildContext context) async {
  final JournalEntry? result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewEntryPage()));
  if (result is JournalEntry) {
    items.add(result);
  }
}

// final List<JournalEntry> entriesList = [];
// const previewLength = 25;
// int _journalIDCoutner = 0;
//
// /// Tags
// class Tag {
//   //add tag list
//   static final Map<String, Tag> tags = {
//      'Calm' : Tag._( 'Calm', const Color(0xff90c6d0)),
//      'Centered': Tag._( 'Centered', const Color(0xff794e5e)),
//      'Content' : Tag._( 'Content', const Color(0xfff1903b)),
//      'Fulfilled': Tag._( 'Fulfilled', const Color(0xff59b1a2)),
//      'Patient' : Tag._( 'Patient', const Color(0xff00c5cc)),
//      'Peaceful': Tag._( 'Peaceful', const Color(0xffa7d7d7)),
//      'Present' : Tag._( 'Present', const Color(0xffff7070)),
//      'Relaxed' : Tag._( 'Relaxed', const Color(0xff3f6962)),
//      'Serene': Tag._( 'Serene', const Color(0xffb7d2c5)),
//      'Trusting': Tag._( 'Trusting', const Color(0xff41aa8c)),
//   };
//   String name;
//   Color color;
//
//   factory Tag(String name, [Color color = Colors.transparent]) {
//     bool exists = tags.containsKey(name);
//     if (!exists) {
//       tags[name] = Tag._(name, color);
//     }
//     return tags[name]!;
//   }
//
//   Tag._(this.name, this.color);
//
// }


// /// Emotions
// class Emotion {
//   static final Map<String, Emotion> emotions = {
//     'Happy': Emotion._('Happy', const Color(0xfffddd68)),
//     'Trust': Emotion._('Trust', const Color(0xff308c7e)),
//     'Fear': Emotion._('Fear', const Color(0xff4c4e52)),
//     'Sad': Emotion._('Sad', const Color(0xff1f3551)),
//     'Disgust': Emotion._('Disgust', const Color(0xff384e36)),
//     'Anger': Emotion._('Anger', const Color(0xffb51c1c)),
//     'Anticipation': Emotion._('Anticipation', const Color(0xffff8000)),
//   };
//
//   String name;
//   Color color;
//
//   factory Emotion(String name, [Color color = Colors.transparent]) {
//     bool exists = emotions.containsKey(name);
//     if (!exists) {
//       emotions[name] = Emotion._(name, color);
//     }
//     return emotions[name]!;
//   }
//
//   Emotion._(this.name, this.color);
// }


// class JournalEntry2 implements Comparable<JournalEntry2> {
//   // unique id for each entry
//   int? id;
//
//   // Journal entry title and body
//   String title = "";
//   String entryText = "";
//   String previewText = "";
//
//   // year, month, day
//   final DateTime creationDate = DateTime.now();
//   List<Tag> tags = [];
//   List<Emotion> emotions = [];
//   List<int> strengths = [];
//
//
//
//   factory JournalEntry2(
//       int id,
//       String title,
//       String entryText,
//       List<Tag> tagList,
//       List<Emotion> emotionList,
//       List<int> strengths) {
//     /// If the entry doesnt exist here, it was just created by the database.
//     Iterable<JournalEntry> found = entriesList.where((element) => element.id == id);
//     if (found.isEmpty){
//       JournalEntry2 x = JournalEntry2._(id, title, entryText, tagList, emotionList, strengths);
//       return x;
//     /// It already exists
//     } else {
//       JournalEntry2 x = found.first;
//       x.title = title;
//       x.entryText = entryText;
//       x.previewText = entryText.substring(0, min(previewLength, entryText.length));
//       x.tags = tagList;
//       x.emotions = emotionList;
//       x.strengths = strengths;
//       return x;
//     }
//   }
//
//   JournalEntry2._(this.id, this.title, this.entryText,  List<Tag> tagList, List<Emotion> emotionList, this.strengths){
//     if (emotionList.length != strengths.length) {
//       throw ArgumentError(
//           "JournalEntry.dart: Emotions and Strengths sizes must be equal.");
//     }
//     previewText = entryText
//         .split("\n")
//         .first
//         .substring(0, min(previewLength, entryText.length));
//     entriesList.add(this);
//     _journalIDCoutner++;
//   }
//
//   JournalEntry2.entry(this.title, this.entryText, List<Tag> tagList, List<Emotion> emotionList, this.strengths){
//     JournalEntry2._(_journalIDCoutner++, title, entryText, tagList, emotionList, strengths);
//   }
//
//   // Get the strongest emotion in the entry
//   Map<int, List<Emotion>>? getStrongestEmotion() {
//     if(strengths.isEmpty) return null;
//     int maxi = strengths.reduce(max);
//     Iterable<int> indexs = strengths.where((element) => element == maxi);
//     List<Emotion> emotes = [];
//     for (int idx in indexs){
//       emotions.add(emotions[idx]);
//     }
//     return {
//       maxi : emotes
//     };
//   }
//
//     /* TODO
// 	List<Image> pictures;
//
// 	List<Image> getPictures();
// 	*/
//
//     /// If this [JournalEntry2] has the same [earliestDate] as [other]
//     /// we will compare them based on the [title]
//     @override
//     int compareTo(JournalEntry2 other) {
//       int order = other.creationDate.compareTo(creationDate) ;
//       return order == 0 ? other.title.compareTo(title) : order;
//     }
