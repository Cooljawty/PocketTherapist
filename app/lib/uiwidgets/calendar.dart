import 'package:flutter/material.dart';

import 'package:app/helper/classes.dart';
import 'package:app/pages/entry.dart';

import 'package:app/helper/dates_and_times.dart';
import 'package:app/provider/settings.dart' as settings;

import 'package:app/pages/entries.dart';

class Calendar extends StatefulWidget {

	@override
	State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
	DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1); 
	DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

	List<({int strength, Color color})> _emotionData = [];

	int _daysFromDate(DateTime day) => day.difference(startDate).inDays;

	///Displays a given day of the month in a container with the color set 
	///according to the strongest emotion of that day (if any)
	Widget _displayDay(day, {outOfRange = false}) => GestureDetector(
		onTap: () => Navigator.of(context).push(EntriesPage.route(startDate: startDate.add(Duration(days: day)))),
		child: Container(
			key: const Key("Calendar_Day"),
			alignment: Alignment.center,
			margin: const EdgeInsets.all(4.0),
			decoration: ShapeDecoration(
				color: outOfRange ? Colors.transparent : _emotionData[day].color, 
				shape: CircleBorder(),
			),
			child: Text(
				"${day+1}", 
				//Have days outside of the current month be greyed out
				style: outOfRange ? settings.getCurrentTheme().textTheme.labelLarge!.copyWith(
					color: settings.getCurrentTheme().textTheme.labelLarge!.color!.withOpacity(0.5)
				)
				: settings.getCurrentTheme().textTheme.labelLarge,
			),
		),
	);

	///Returns the full grid of dates including the days of the last and 
	///next month that would be part of the week
	List<Widget> _getCalendarDays() {
		final datesInRange = <Widget>[];
		for (var day = 0; day <= _daysFromDate(endDate); day += 1) {
			datesInRange.add(_displayDay(day));
		}

		//Fill the start and end to line up weekdays
		final startFirstWeek = startDate!.subtract(Duration(days: startDate.weekday));
		final prePaddedDays = List<Widget>.generate(startDate.weekday - 1, (day) {
			return _displayDay( startFirstWeek.day + day, outOfRange: true);
		});
		final postPaddedDays = List<Widget>.generate(7 - endDate.weekday, (day) {
			return _displayDay(day, outOfRange: true);
		});

		return prePaddedDays + datesInRange + postPaddedDays;
	}
	
	@override
	Widget build(BuildContext context) {
		//Calculate the emotion data for each day
		_emotionData = List.filled(_daysFromDate(endDate) +1, (strength: 0, color: Colors.transparent));
		for (var entry in entriesBetween(startDate, endDate)) {
			final strongestEmotion = entry.getStrongestEmotion();
			if (strongestEmotion.strength > _emotionData[_daysFromDate(entry.getDate())].strength) {
				_emotionData[_daysFromDate(entry.getDate())] = (
					strength: strongestEmotion.strength, 
					color: strongestEmotion.color
				);
			}
		}

		return Card(
			key: const Key("Calendar_Panel"),
			child: Column(
				children: [
					Container(
						margin: const EdgeInsets.only(top: 13) + EdgeInsets.symmetric(horizontal: 14),
						child: Row( 
							children: [
								IconButton(
									icon: const Icon(
										Icons.navigate_before, 
									),
									onPressed: ()=> setState(() {
										final range = endDate.difference(startDate);
										startDate = DateTime(startDate.year, startDate.month - 1, 1);
										endDate = DateTime(startDate.year, startDate.month + 1, 0);
									}),
								),
								Expanded( 
									child: Text(
										"${startDate.formatDate().month}" 
										+ ((startDate.year != DateTime.now().year) ? " ${startDate.year}" : ""), 
										style: settings.getCurrentTheme().textTheme.titleLarge,
										textAlign: TextAlign.center,
									), 
								),
								IconButton(
									icon: const Icon(
										Icons.navigate_next, 
									),
									onPressed: ()=> setState(() {
										startDate = DateTime(startDate.year, startDate.month + 1, 1);
										endDate = DateTime(startDate.year, startDate.month + 1, 0);
									}),
								),
							]
						),
					),
					Divider(),
					Row( 
						children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((weekday) {
							return Expanded( 
								child: Text( weekday, textAlign: TextAlign.center)
							);
						}).toList(),
					),
					GridView.count(
						key: const Key("Calendar_Grid"),
						crossAxisCount: 7,
						padding: const EdgeInsets.all(4.0),
						shrinkWrap: true,
						children: _getCalendarDays(),
					),
				]
			),
		);
	}
}

//TODO replace with database
List<JournalEntry> entriesBetween(DateTime start, DateTime end) {
	final testEntries = <JournalEntry>[
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 11, 1), 
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
				date: DateTime(2023, 11, 1), 
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
				date: DateTime(2023, 11, 2), 
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
				date: DateTime(2023, 11, 3), 
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
				date: DateTime(2023, 11, 3), 
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
				date: DateTime(2023, 11, 17), 
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
				date: DateTime(2023, 11, 25), 
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
				date: DateTime(2023, 11, 30), 
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
				date: DateTime(2023, 11, 26), 
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
				date: DateTime(2023, 11, 12), 
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
				date: DateTime(2023, 11, 11), 
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime.now(), 
				emotions: [
					Emotion(
						name: "Happy",
						color: Color(0xfffddd68),
						strength: 30,
					),
				]
			),
			JournalEntry(
				title: "Happy day", entryText: "", 
				date: DateTime(2023, 11, 24), 
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
				date: DateTime(2023, 11, 14), 
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
