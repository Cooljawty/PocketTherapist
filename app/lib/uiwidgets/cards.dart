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
	return Center(
	  child: ListView.builder(
			itemCount: widget.content.length,
			itemBuilder: (BuildContext context, int index) {
				return Container(
					child: Center(child: Text("${widget.content[index]}")),
				);
			}
		),
	);
  }
}
