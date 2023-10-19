import 'package:flutter/material.dart';
import 'package:app/pages/entry.dart';

/// A card that displays a journal entry with title and preview text
class DisplayCard extends StatefulWidget {
	final Map<String,String> entry;

  const DisplayCard({super.key, required this.entry});

	@override
	State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
	@override
  Widget build(BuildContext context) {

		//Text style is taken from app theme
		final theme = Theme.of(context);
		final titleStyle = theme.textTheme.titleMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);
		final previewStyle = theme.textTheme.bodyMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);

		return  Container(
			//The card should take the full width of the screen (with some padding)
			margin: const EdgeInsets.all(2),
			padding: const EdgeInsets.symmetric(horizontal: 12),
			width: MediaQuery.of(context).size.width,
			
			//Uses gesture detector to enable interactivity
			child: GestureDetector(
				onTap: () {
					Navigator.of(context).pushReplacement(EntryPage.route(entry: widget.entry));
				},

				child: Card( 
					color: theme.colorScheme.background, 
					shape: RoundedRectangleBorder(
						side: BorderSide(
							color: Theme.of(context).colorScheme.outline,
						),
						borderRadius: const BorderRadius.all(Radius.circular(4)),
					),

					//Here is where the content is displayed
					child: Container(
						padding: const EdgeInsets.all(12),
						child: Wrap( 
							direction: Axis.vertical,
							spacing: 3.0,
							children: <Widget>[ 
								Text( "${widget.entry['title']}", style: titleStyle, ),
								Text( "${widget.entry['previewText']}", style: previewStyle, ), 
							],
						),
					),
				),
			),
		);
	}
}
