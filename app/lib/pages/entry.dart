import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';

import 'dart:math';

class JournalEntry with DisplayOnCard {
	String _title = "";
	String _previewText = "";
	String _entryText = "";
	// year, month, day
	DateTime current = DateTime.now();
	DateTime _date = DateTime(1970, 12, 31);

	static const previewLength = 25;

	JournalEntry({required title, required entryText, required date}){
		_title = title;
		_entryText = entryText;
		_date = date;
		
		final preview = _entryText.split("\n").first;
		_previewText = preview.substring(0, min(previewLength, preview.length));

		card = (
			title: _title,
			body: getPreviewText(),
		  date: _date,
		);	

		pageRoute = EntryPage.route(entry: this);
	}
	String getPreviewText() => _previewText;
	String getEntryText() => _entryText;
	String getTitle() => _title;
	DateTime getDate() => _date;

	/* TODO
	int _id;
	int getId();
	DateTime _date;
	List<Tag> tags;
	List<Emotions> emotions;
	List<Image> pictures;

	DateTime getDate();
	Tag getTagByTitle(String title);
	List<Tags> getTags();
	Emotion getStrongestEmotion();
	List<Emotion> getEmotions();
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
										Text( widget.entry.getTitle()),
									],
								),
							),
							//Content
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.vertical,
									children: <Widget>[ 
										Text( widget.entry.getEntryText()),
									],
								),
							),
						],
					),
				),
			),
    );
  }
}
