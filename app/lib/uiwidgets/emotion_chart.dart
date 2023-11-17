import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:app/pages/entry.dart';

import 'package:app/provider/settings.dart';


enum GraphTypes{ time, frequency }

/// [EmotionGraph] is a panel that grabs all entries withing a given date range and displys
/// either a line plot of the intesity of that emotion over the range, or the relative
/// intensities of each emotion in a radial chart
class EmotionGraph extends StatefulWidget {
	final DateTime startDate; 
	final DateTime endDate;
	final GraphTypes type;

	const EmotionGraph({
		super.key, 
		required this.startDate, 
		required this.endDate, 
		required this.type
	});

	@override
	State<EmotionGraph> createState() => _EmotionGraphState();
}

class _EmotionGraphState extends State<EmotionGraph> {
	static const MAX_STRENGTH = 60.0;

	/* 
		"Emotion 1": [
			day 1: (day 1, max strength),
			..
			day n: (day n, max strength)
		],
		..
		"Emotion n": [
			day 1: (day 1, max strength),
			..
			day n: (day n, max strength)
		]
	*/
	Map<String, List<FlSpot>> _emotionData = {};
	
	//Radial equation
	// sum (emotion.strength) / (max intensity * date_range)

	//X is the number of days from the start entry
	double getX(JournalEntry entry) => entry.getDate().difference(widget.startDate).inDays.toDouble().floorToDouble();
	double getXFromDay(DateTime day) => day.difference(widget.startDate).inDays.toDouble().floorToDouble();

	@override
	Widget build(BuildContext context) {
		final entries = entriesBetween(widget.startDate, widget.endDate); 

		//Calculate sum strength for each emotion
		for (var entry in entries){
			for (var emotion in entry.getEmotions()){
				final dayIndex = getX(entry).floor();
				var point = _emotionData[emotion.name]![dayIndex];
				//Set the y position has the highest intensity of the day
				if (point == null) {
					_emotionData[emotion.name]![dayIndex] = FlSpot(getX(entry), emotion.strength);
				} else {
					_emotionData[emotion.name]![dayIndex] = FlSpot(getX(entry), math.max(point.y, emotion.strength));
				}
			}
		} 	

		//Have non-entry days be 0
		for (var emotion in emotionlist) { 
			for (var day = widget.startDate; day.isBefore(widget.endDate); day.add(const Duration(days: 1))){
				//Emotions that don't show up in entries are ignored
				_emotionData[emotion]?[getXFromDay(day).floor()] ??= FlSpot(getXFromDay(day), 0);     
			}
		}

		return Container( 
			padding: const EdgeInsets.all(6.0),
			child: switch(widget.type) {
				//Time graph
				GraphTypes.time => LineChart(
					LineChartData(
						minX: 0, maxX: getXFromDay(widget.endDate),
						minY: 0, maxY: MAX_STRENGTH,
						//Create a line for each emotion 
						lineBarsData: _emotionData.entries.map((entry) {
							final emotion = entry.key;
							final data = entry.value;
							return LineChartBarData(
								spots: data,
								color: emotionlist[emotion].getColor(),
								isCurved: true,
								curveSmoothness: 0.35,
							);
						}).toList(),
					),
				),
				//Frequency graph
				GraphTypes.frequency => null, //TODO
			}
		);
	}
}

//TEMPERARY Variables/Classes
const emotionlist = ["Happy", "Sad", "Angry"];
List<JournalEntry> entriesBetween(DateTime start, DateTime end) {
	final testEntries = <JournalEntry>[
			JournalEntry(
				title: "Day one entry 1", entryText: "", 
				date: DateTime(2023, 1, 1), 
			),
			JournalEntry(
				title: "Day one entry 2", entryText: "", 
				date: DateTime(2023, 1, 1), 
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 2), 
			),
			JournalEntry(
				title: "Day thrree entry 1", entryText: "", 
				date: DateTime(2023, 1, 3), 
			),
			JournalEntry(
				title: "Day thrree entry 2", entryText: "", 
				date: DateTime(2023, 1, 3), 
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 4), 
			),
			JournalEntry(
				title: "", entryText: "", 
				date: DateTime(2023, 1, 5), 
			),
			JournalEntry(
				title: "Out of range entry", entryText: "", 
				date: DateTime(2023, 1, 14), 
			),
		];

	testEntries.retainWhere((e) => e.getDate().isAfter(start) && e.getDate().isBefore(start));
	return testEntries;
}
