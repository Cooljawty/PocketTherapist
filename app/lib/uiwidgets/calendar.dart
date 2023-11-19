import 'package:flutter/material.dart';

import 'package:app/helper/classes.dart';
import 'package:app/pages/entry.dart';

class Calendar extends StatefulWidget {
	final DateTime startDate; 
	final DateTime endDate;

	const Calendar({
		super.key, 
		required this.startDate, 
		required this.endDate, 
	});

	@override
	State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
	List<({int strength, Color color})> _emotionData = [];

	int _daysFromDate(DateTime day) => day.difference(widget.startDate).inDays;

	static const _months = [ null, 
		"January", "February", 
		"March", "April", "May", 
		"June", "July", "August", 
		"November", "October", "November", 
		"December"
	];

	final _weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) {
		return Expanded( child: Text(day, textAlign: TextAlign.center) );
	}).toList();


	Widget _displayDay(day, {outOfRange = false}) => Container(
		alignment: Alignment.center,
		margin: const EdgeInsets.all(4.0),
		decoration: ShapeDecoration(
			color: outOfRange ? Colors.transparent : _emotionData[day].color, 
			shape: CircleBorder(),
		),
		child: Text(
			"${day+1}", 
			style: outOfRange 
			? Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).textTheme.labelLarge!.color!.withOpacity(0.5))
			: Theme.of(context).textTheme.labelLarge,
		),
	);

	List<Widget> _getCalendarDays() {
		final datesInRange = <Widget>[];
		for (var day = 0; day <= _daysFromDate(widget.endDate); day += 1) {
			datesInRange.add(_displayDay(day));
		}

		//Fill the start and end to line up weekdays
		final prefix = List<Widget>.generate(widget.startDate.weekday - 1, (day) => _displayDay(widget.startDate!.subtract(Duration(days: 1)).day - day, outOfRange: true));
		final suffix = List<Widget>.generate(7 - widget.endDate.weekday, (day) => _displayDay(day, outOfRange: true));

		return prefix + datesInRange + suffix;
	}
	
	@override
	Widget build(BuildContext context) {
		final entries = entriesBetween(widget.startDate, widget.endDate); 
		_emotionData = List.filled(_daysFromDate(widget.endDate) +1, (strength: 0, color: Colors.transparent));
		for (var entry in entries) {
			final strongestEmotion = entry.getStrongestEmotion();
			if (strongestEmotion.strength > _emotionData[_daysFromDate(entry.getDate())].strength) {
				_emotionData[_daysFromDate(entry.getDate())] = (
					strength: strongestEmotion.strength, 
					color: strongestEmotion.color
				);
			}
		}

		return Card(
			child: Column(
				children: [
					Container(
						margin: const EdgeInsets.only(top: 13),
						child: Text(_months[widget.startDate.month]!, style: Theme.of(context).textTheme.titleLarge)
					),
					Divider(),
					Row( children: _weekdays ),
					GridView.count(
						key: const Key("Calendar_Panel"),
						crossAxisCount: 7,
						padding: const EdgeInsets.all(4.0),
						//childAspectRatio: 0.8,
						shrinkWrap: true,
						//Calculating each day
						children: _getCalendarDays(),
					),
				]
			),
		);
	}
}

List<JournalEntry> entriesBetween(DateTime start, DateTime end) {
	final testEntries = <JournalEntry>[
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 1, 1), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 2", entryText: "", 
				date: DateTime(2023, 1, 1), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 2), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 8,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 1", entryText: "", 
				date: DateTime(2023, 1, 3), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 15,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 2", entryText: "", 
				date: DateTime(2023, 1, 3), 
				emotions: [
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 1, 17), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "Day one entry 2", entryText: "", 
				date: DateTime(2023, 1, 25), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 30), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 8,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 1", entryText: "", 
				date: DateTime(2023, 1, 26), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 15,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Day thrree entry 2", entryText: "", 
				date: DateTime(2023, 1, 12), 
				emotions: [
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 60,
					),
				]
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 11), 
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime(2023, 1, 24), 
				emotions: [
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Out of range entry", entryText: "", 
				date: DateTime(2023, 1, 14), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 60,
					),
					Emotion(
						name: "Happy",
						color: Colors.green,
						strength: 30,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 30,
					),
				]
			),
		];

	testEntries.retainWhere((e) => ( !e.getDate().isBefore(start) && !e.getDate().isAfter(end)));
	testEntries.sort((a, b) => a.getDate().compareTo(b.getDate()));
	return testEntries;
}
