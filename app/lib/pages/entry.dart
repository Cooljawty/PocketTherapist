import 'package:app/pages/entries.dart';
import 'package:flutter/material.dart';

class EntryPage<T> extends StatefulWidget {
	final Map<String,String> entry;

	/// Route for navigator to open page with a given entry
  static Route<dynamic> route({entry}) {
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
										Text( "${widget.entry['title']}", style: titleStyle),
									],
								),
							),
							//Content
							Container(
								padding: const EdgeInsets.all(12),
								child: Wrap( 
									direction: Axis.vertical,
									children: <Widget>[ 
										Text( "${widget.entry['entryText']}", style: textStyle), 
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
