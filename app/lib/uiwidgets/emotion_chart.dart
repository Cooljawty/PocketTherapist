import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/provider/entry.dart';
import 'package:app/provider/settings.dart' as settings;

/// Graph Types
/// An enum for each graph type an [EmotionGraph] can be displayed as
enum GraphTypes {
  time,
  frequency;

  @override
  String toString() => name.split('.').last;
}

/// [EmotionGraph] is a panel that grabs all entries withing a given date range and displys
/// either a line plot of the intesity of that emotion over the range, or the relative
/// intensities of each emotion in a radial chart
class EmotionGraph extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final GraphTypes type;

  EmotionGraph(
      {super.key, required this.startDate, required this.endDate, type})
      : type = type ?? settings.getEmotionGraphType();

  @override
  State<EmotionGraph> createState() => _EmotionGraphState();
}

class _EmotionGraphState extends State<EmotionGraph> {
  static const maxStrength = 60.0;

  static const _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "November",
    "October",
    "November",
    "December"
  ];

  String _daySuffix(day) =>
      switch (day) { 1 => "1st", 2 => "2nd", 3 => "3rd", _ => "${day}th" };

  Map<String, List<FlSpot>> _emotionData = {};

  //X is the number of days from the start entry
  double getX(JournalEntry entry) =>
      entry.creationDate.difference(widget.startDate).inDays.floorToDouble();
  double getXFromDay(DateTime day) =>
      day.difference(widget.startDate).inDays.toDouble().floorToDouble();

  Widget _getTimeChart() {
    final gridColor = settings.getCurrentTheme().colorScheme.onBackground;

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          //Only show time at bottom
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: _getTimeTitles,
            ),
          ),
        ),

        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipBgColor: settings.getCurrentTheme().colorScheme.background,
            tooltipBorder: BorderSide(color: gridColor),
            getTooltipItems: (spots) => spots.map((spot) {
              final emotion = _emotionData.keys.elementAt(spot.barIndex);
              final value =
                  ((spot.bar.spots[spot.spotIndex].y / maxStrength) * 100)
                      .round();

              return LineTooltipItem("$emotion: ",
                  settings.getCurrentTheme().textTheme.displayMedium!,
                  //Print value in emotion's color
                  children: [
                    TextSpan(
                      text: "$value%",
                      style: settings
                          .getCurrentTheme()
                          .textTheme
                          .displayMedium!
                          .copyWith(color: emotionList[emotion]),
                    )
                  ]);
            }).toList(),
          ),
        ),

        minX: 0.0, maxX: getXFromDay(widget.endDate),
        minY: 0.0, maxY: maxStrength,
        gridData: FlGridData(
          drawHorizontalLine: false,
          drawVerticalLine: true,
          verticalInterval: 1,
          getDrawingVerticalLine: (_) => FlLine(
            dashArray: [1, 0],
            strokeWidth: 0.8,
            color: gridColor,
          ),
        ),

        borderData: FlBorderData(border: Border.all(color: gridColor)),

        //Create a line for each emotion
        lineBarsData: _emotionData.entries
            .map((entry) => LineChartBarData(
                  show: entry.value.any((value) => value.y != 0),
                  spots: entry.value,
                  color: emotionList[entry.key],
                  dotData: const FlDotData(
                    show: false,
                  ),
                  isCurved: true,
                  curveSmoothness: 0.5,
                  barWidth: 4.5,
                  preventCurveOverShooting: true,
                  preventCurveOvershootingThreshold: 2,
                ))
            .toList(),
      ),
    );
  }

  Widget _getFrequencyChart() {
    final gridColor = settings.getCurrentTheme().colorScheme.onBackground;

    //Summ up the strength of all entreis
    final emotionValues = _emotionData.entries.map((entry) {
      final sum = entry.value.fold(0.0, (sum, strength) => sum += strength.y);
      return RadarEntry(
          value: sum / (maxStrength * getXFromDay(widget.endDate)));
    }).toList();

    //Find the strongest emotion based on calculated radial values
    var max = 0.0;
    var index = emotionValues.lastIndexWhere((emotion) {
      if (emotion.value > max) {
        max = emotion.value;
        return true;
      } else {
        return false;
      }
    });
    Color strongestEmotion = index == -1
        ? Colors.transparent
        : emotionList[_emotionData.keys.elementAt(index)] as Color;

    return Container(
      padding: const EdgeInsets.only(
        top: 14,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 24,
      ),
      decoration: ShapeDecoration(
        color: settings.getCurrentTheme().colorScheme.background,
        shape: settings.getCurrentTheme().cardTheme.shape!,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: RadarChart(
          RadarChartData(
            radarShape: RadarShape.polygon,
            borderData: FlBorderData(show: true),
            //titlePositionPercentageOffset: 0.068,
            getTitle: (index, angel) =>
                RadarChartTitle(text: _emotionData.keys.elementAt(index)),
            //Hide value ticker
            ticksTextStyle:
                const TextStyle(color: Colors.transparent, fontSize: 10),
            tickBorderData: const BorderSide(color: Colors.transparent),
            radarBorderData: BorderSide(color: gridColor),
            gridBorderData: BorderSide(color: gridColor, width: 2),
            dataSets: [
              RadarDataSet(
                entryRadius: 0.0,
                borderColor: strongestEmotion,
                fillColor: strongestEmotion.withOpacity(0.5),
                dataEntries: emotionValues,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTimeTitles(double value, TitleMeta meta) {
    final day = widget.startDate.add(Duration(days: value.toInt())).day;

    final startOfWeek =
        widget.startDate.add(Duration(days: value.floor())).weekday ==
            widget.startDate.weekday;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      //Dont label last line if it's not the end of the week
      child: Text(
          (startOfWeek || getXFromDay(widget.endDate) <= 7.0)
              ? "${widget.startDate.month}/$day"
              : "",
          style: settings.getCurrentTheme().textTheme.labelMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    _emotionData = Map.fromIterable(emotionList.keys,
        value: (i) => List<FlSpot>.generate(
            getXFromDay(widget.endDate).floor() + 1,
            (day) => FlSpot(day.toDouble(), 0)));

    //Calculate sum strength for each emotion
    for (var entry
        in entriesInDateRange(widget.startDate, widget.endDate, entries)) {
      for (var emotion in entry.emotions) {
        final dayIndex = getX(entry).floor();
        //Set the y position has the highest intensity of the day
        if (dayIndex < _emotionData[emotion.name]!.length) {
          _emotionData[emotion.name]![dayIndex] = FlSpot(
              getX(entry),
              math.max(_emotionData[emotion.name]![dayIndex].y,
                  emotion.strength.toDouble()));
        } else {
          _emotionData[emotion.name]![dayIndex] =
              FlSpot(getX(entry), emotion.strength.toDouble());
        }
      }
    }

    return Expanded(
      child: Card(
        //aspectRatio: 1.75,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${_months[widget.startDate.month]} ${_daySuffix(widget.startDate.day)} - ${_daySuffix(widget.endDate.day)}",
                  style: settings.getCurrentTheme().textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: switch (widget.type) {
                GraphTypes.time => _getTimeChart(),
                GraphTypes.frequency => _getFrequencyChart()
              }),
            ],
          ),
        ),
      ),
    );
  }
}



// final testEntries = <JournalEntry>[
// 	JournalEntry(
// 			title: "Day one entry 1", entryText: "",
// 			date: DateTime(2023, 1, 1),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 60,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day one entry 2", entryText: "",
// 			date: DateTime(2023, 1, 1),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 30,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "", entryText: "",
// 			date: DateTime(2023, 1, 2),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 30,
// 				),
// 				Emotion(
// 					name: "Anger",
// 					color: Colors.red,
// 					strength: 8,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day thrree entry 1", entryText: "",
// 			date: DateTime(2023, 1, 3),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 15,
// 				),
// 				Emotion(
// 					name: "Happy",
// 					color: Colors.green,
// 					strength: 30,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day thrree entry 2", entryText: "",
// 			date: DateTime(2023, 1, 3),
// 			emotions: [
// 				Emotion(
// 					name: "Anger",
// 					color: Colors.red,
// 					strength: 60,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day one entry 1", entryText: "",
// 			date: DateTime(2023, 1, 17),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 60,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day one entry 2", entryText: "",
// 			date: DateTime(2023, 1, 25),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 30,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "", entryText: "",
// 			date: DateTime(2023, 1, 30),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 30,
// 				),
// 				Emotion(
// 					name: "Anger",
// 					color: Colors.red,
// 					strength: 8,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day thrree entry 1", entryText: "",
// 			date: DateTime(2023, 1, 26),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 15,
// 				),
// 				Emotion(
// 					name: "Happy",
// 					color: Colors.green,
// 					strength: 30,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Day thrree entry 2", entryText: "",
// 			date: DateTime(2023, 1, 12),
// 			emotions: [
// 				Emotion(
// 					name: "Anger",
// 					color: Colors.red,
// 					strength: 60,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 		title: "", entryText: "",
// 		date: DateTime(2023, 1, 11),
// 	),
// 	JournalEntry(
// 			title: "Happy day", entryText: "",
// 			date: DateTime(2023, 1, 24),
// 			emotions: [
// 				Emotion(
// 					name: "Happy",
// 					color: Colors.green,
// 					strength: 30,
// 				),
// 			]
// 	),
// 	JournalEntry(
// 			title: "Out of range entry", entryText: "",
// 			date: DateTime(2023, 1, 14),
// 			emotions: [
// 				Emotion(
// 					name: "Sad",
// 					color: Colors.blue,
// 					strength: 60,
// 				),
// 				Emotion(
// 					name: "Happy",
// 					color: Colors.green,
// 					strength: 30,
// 				),
// 				Emotion(
// 					name: "Anger",
// 					color: Colors.red,
// 					strength: 30,
// 				),
// 			]
// 	),
// ];
