import 'package:flutter/material.dart';
/// A genaric card for displaying journal entries and plans
class DisplayCard extends StatefulWidget {
	final Map<String,String> entry;

  const DisplayCard({super.key, required this.entry});

	@override
	State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
	@override
  Widget build(BuildContext context) {
		final theme = Theme.of(context);

		final titleStyle = theme.textTheme.titleMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);
		final previewStyle = theme.textTheme.bodyMedium!.copyWith(
			color: theme.colorScheme.onBackground,
		);

		return  Container(
			margin: const EdgeInsets.all(2),
			padding: const EdgeInsets.symmetric(horizontal: 12),
			width: MediaQuery.of(context).size.width,
			child: Card( 
				color: theme.colorScheme.background, 
				shape: RoundedRectangleBorder(
					side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
				),
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
		);
	}
}
