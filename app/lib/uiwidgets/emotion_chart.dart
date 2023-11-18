import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/helper/classes.dart';
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

	Map<String, List<FlSpot>> _emotionData = {};
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
	
	//Radial equation
	// sum (emotion.strength) / (max intensity * date_range)

	//X is the number of days from the start entry
	double getX(JournalEntry entry) => entry.getDate().difference(widget.startDate).inDays.floorToDouble();
	double getXFromDay(DateTime day) => day.difference(widget.startDate).inDays.toDouble().floorToDouble();

	@override
	Widget build(BuildContext context) {
		final entries = entriesBetween(widget.startDate, widget.endDate); 
		_emotionData = Map.fromIterable(emotionlist.keys, value: (i) => List<FlSpot>.generate(getXFromDay(widget.endDate).floor()+1, (day) => FlSpot(day.toDouble(), 0)));

		//Calculate sum strength for each emotion
		for (var entry in entries){
			for (var emotion in entry.getEmotions()){
				final dayIndex = getX(entry).floor();
				//Set the y position has the highest intensity of the day
				if (dayIndex < _emotionData[emotion.name]!.length) {
					_emotionData[emotion.name]![dayIndex] = FlSpot(getX(entry), math.max(_emotionData[emotion.name]![dayIndex].y, emotion.strength.toDouble()));
				} else {
					_emotionData[emotion.name]![dayIndex] = FlSpot(getX(entry), emotion.strength.toDouble());
				}
			}
		} 	

		return AspectRatio( 
			aspectRatio: 1.75,
			child: Padding(
				padding: const EdgeInsets.all(12.0),
				child: switch(widget.type) {
					//Time graph
					GraphTypes.time => LineChart(
						LineChartData(
							titlesData: FlTitlesData(show: false),
							minX: 0.0, maxX: getXFromDay(widget.endDate),
							minY: 0.0, maxY: MAX_STRENGTH,
							gridData: FlGridData(
								show: true,
								drawHorizontalLine: false,
								drawVerticalLine: true,
								verticalInterval: 1,
								getDrawingVerticalLine: (_) => FlLine(
									dashArray: [1, 0],
									strokeWidth: 0.8,
									color: Colors.grey, 
								),
							),
							//Create a line for each emotion 
							lineBarsData: _emotionData.entries.map((entry) => LineChartBarData(
									show: entry.value.any((value) => value.y != 0),
									spots: entry.value,
									color: emotionlist[entry.key]!.color,
									dotData: const FlDotData( show: false, ),
									isCurved: true,
									curveSmoothness: 0.5,
									barWidth: 4.5,
									preventCurveOverShooting: true,
									preventCurveOvershootingThreshold: 2,
								),
							).toList(),
						),
					),
					//Frequency graph
					GraphTypes.frequency => null, //TODO
				}
			),
		);
	}
}

//TEMPERARY Variables/Classes
final emotionlist = {
	"Happy": Emotion(name: "Happy", color: Colors.green, strength: 0), 
	"Sad": Emotion(name: "Sad", color: Colors.blue, strength: 0), 
	"Angry": Emotion(name: "Angry", color: Colors.red, strength: 0),
	"Sonder": Emotion(name: "Sonder", color: Colors.orange, strength: 0),
};
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
				emotions: [
					Emotion(
						name: "Angry",
						color: Colors.red,
						strength: 30,
					),
				]
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
			/*
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
			*/
		];

	//testEntries.retainWhere((e) => ( e.getDate().compareTo(start) <= 0 && e.getDate().compareTo(start) >= 0));
	return testEntries;
}
