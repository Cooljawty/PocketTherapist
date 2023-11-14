import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';
import 'package:app/helper/classes.dart';

import 'dart:math';

class JournalEntry with DisplayOnCard {


	// Journal entry title and body
	String _title = "";
	String _entryText = "";
	String _previewText = "";

	// Associated tags/emotions
	//List<Tag> _tags = [];
	//List<Emotions> _emotions = [];

	// year, month, day
	DateTime current = DateTime.now();
	DateTime _date = DateTime(1970, 12, 31);
	List<Tag> _tags = [];
	List<Emotion> _emotions = [];

	static const previewLength = 25;

	JournalEntry({required title, required entryText, required date, tags, emotions}){
		_title = title;
		_entryText = entryText;
		_date = date;
		_tags = tags ?? [];
		_emotions = emotions ?? [];
		
		final preview = _entryText.split("\n").first;
		_previewText = preview.substring(0, min(previewLength, preview.length));

		card = (
			title: _title,
			body: getPreviewText(),
		  date: _date,
		);

		pageRoute = (() => EntryPage.route(entry: this));
	}
	String getPreviewText() => _previewText;
	String getEntryText() => _entryText;
	String getTitle() => _title;
	DateTime getDate() => _date;
	List<Tag> getTags() => _tags;
	List<Emotion> getEmotions() => _emotions;

	/* TODO
	List<Image> pictures;

	Tag getTagByTitle(String title);
	Emotion getStrongestEmotion();
	List<Image> getPictures();
	*/
}

class EntryPage extends StatefulWidget {
	final JournalEntry entry;

	/// Route for navigator to open page with a given entry
  static Route<dynamic> route({required JournalEntry entry}) {
    return MaterialPageRoute(builder: (context) => EntryPage(entry: entry));
  }

  const EntryPage({super.key, required this.entry});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: SafeArea(
				child: Center(
					child: Column(
						children: <Widget>[ 
							//Title
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.vertical,
									children: <Widget>[
										Text(widget.entry.getTitle()),
									],
								),
							),

							//Entry text
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.vertical,
									children: <Widget>[ 
										Text( widget.entry.getEntryText()),
									],
								),
							),

							// Tags
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.horizontal,
									children: widget.entry.getTags().map((tag) => Text(
											"#${tag.name} ",
											selectionColor: tag.color
										)).toList(),
								),
							),

							// Emotions
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap(
									direction: Axis.horizontal,
									children: widget.entry.getEmotions().map((emotion) => Text(
											"${emotion.name} : ${emotion.strength} \t",
											selectionColor: emotion.color
									)).toList(),
								),
							),
						],
					),
				),
			),
    );
  }
}
