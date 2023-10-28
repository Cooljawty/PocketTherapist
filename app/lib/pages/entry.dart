import 'package:flutter/material.dart';
import 'package:app/uiwidgets/cards.dart';

import 'dart:math';

class JournalEntry with DisplayOnCard {
	String _title = "";
	String _previewText = "";
	String _entryText = "";

	static const previewLength = 25;

	JournalEntry({required title, required entryText}){
		_title = title;
		_entryText = entryText;
		
		_previewText = getPreviewText();

		card = (
			title: this._title,
			body: getPreviewText(),
		);	

		pageRoute = EntryPage.route(entry: this);
	}
	String getPreviewText() {
		var preview = _entryText.split("\n").first;
		return preview.substring(0, min(previewLength, preview.length));
	} 

	String getEntryText() => _entryText;
	String getTitle() => _title;

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
		//Text style is taken from app theme
		final theme = Theme.of(context);
		final titleStyle = theme.textTheme.titleMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);
		final textStyle = theme.textTheme.bodyMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);

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
										Text( "${widget.entry.getTitle()}", style: titleStyle),
									],
								),
							),
							//Content
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.vertical,
									children: <Widget>[ 
										Text( "${widget.entry.getEntryText()}", style: textStyle), 
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
