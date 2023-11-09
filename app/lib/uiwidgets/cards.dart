import 'package:flutter/material.dart';

/// A card that displays text with a title and main text bocy
class DisplayCard extends StatefulWidget {
	final String title;
	final String body;

	final dynamic page;

  const DisplayCard({super.key, required this.title, required this.body, this.page});

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
					if(widget.page != null) {
						final route = widget.page!;
						Navigator.of(context).push(route());
					}
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
					child: Wrap( 
						direction: Axis.vertical,
						children: <Widget>[ 
							Container(
								padding: const EdgeInsets.all(6),
								child: Text( widget.title, style: titleStyle, ),
							),
							Container(
								padding: const EdgeInsets.all(6),
								child: Text( widget.body, style: previewStyle, ), 
							),
						],
					),
				),
			),
		);
	}
}

mixin DisplayOnCard{
	({String title, String body}) card = (title: "", body: "");

	dynamic pageRoute;

	DisplayCard asDisplayCard() {
		return DisplayCard(title: card.title, body: card.body, page: pageRoute);
	}
}
