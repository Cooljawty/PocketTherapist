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

		return Flexible(
			fit: FlexFit.tight,
			flex: 1,
			child: Center( 
				child: Card( 
					color: theme.colorScheme.background, 
					child: Container(
						margin: const EdgeInsets.all(4),
						padding: const EdgeInsets.all(8),
						decoration: BoxDecoration( border: Border.all(), borderRadius: BorderRadius.circular(8),), 
						child: Column( 
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[ 
								Text( "${widget.entry['title']}", style: titleStyle,),
								Text( "${widget.entry['previewText']}", style: previewStyle,), 
							],
						),
					),
				),
			),
		);
	}
}
