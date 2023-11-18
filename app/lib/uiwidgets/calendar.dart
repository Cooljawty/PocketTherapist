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

	List<Widget> _getCalendarDays() {
		final datesInRange = <Card>[];
		for (var day = 0; day <= _daysFromDate(widget.endDate); day += 1) {
			datesInRange.add( Card(
				color: _emotionData[day].color, 
				child: Text("${day+1}", style: Theme.of(context).textTheme.labelLarge),
			));
		}

		//Fill the start and end to line up weekdays
		final prefix = List<Card>.filled(widget.startDate.weekday - 1, Card());
		final suffix = List<Card>.filled(7 - widget.endDate.weekday, Card());

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
					Text("Month", style: Theme.of(context).textTheme.titleLarge),
					Divider(),
					GridView.count(
						key: const Key("Calendar_Panel"),
						crossAxisCount: 7,
						padding: const EdgeInsets.all(4.0),
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
				title: "", entryText: "", 
				date: DateTime(2023, 1, 4), 
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 5), 
				emotions: [
					Emotion(
						name: "Sad",
						color: Colors.blue,
						strength: 5,
					),
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 18,
					),
				]
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime(2023, 1, 31), 
				emotions: [
					Emotion(
						name: "Sonder",
						color: Colors.orange,
						strength: 30,
					),
				]
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
