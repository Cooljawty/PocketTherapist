import 'package:flutter/material.dart';
/// A genaric card for displaying journal entries and plans
class DisplayCard extends StatefulWidget {
	final List<String> content;

  const DisplayCard({super.key, required this.content});

	@override
	State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
	@override
  Widget build(BuildContext context) {
		return Flexible(
			fit: FlexFit.tight,
			flex: 1,
			child: Center( 
				child: Card( 
					child: ListView.builder(
						scrollDirection: Axis.horizontal,
						padding: const EdgeInsets.all(8),
						itemCount: widget.content.length,
						itemBuilder: (BuildContext context, int index) {
							return Text("${widget.content[index]}");
						}
					),
				),
			),
		);
  }
}
