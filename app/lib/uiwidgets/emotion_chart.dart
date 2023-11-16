import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:app/pages/entry.dart';
import 'package:app/providers/settings.dart';

enum GraphTypes{ time, frequency };

/// [EmotionGraph] is a panel that grabs all entries withing a given date range and displys
/// either a line plot of the intesity of that emotion over the range, or the relative
/// intensities of each emotion in a radial chart
class EmotionGraph extends StatefulWidget {
	final DateTime startDate, 
	final DateTime endDate, 
	final GraphTypes type

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
	const MAX_STRENGTH = 60.0;
	Map<Emotion, List<F1Spot>> _emotionData = {};
	
	//Radial equation
	// sum (emotion.strength) / (max intensity * date_range)
	@override
	widget build(BuildContext context) {
		final entries = entriesBetween(widget.startDate, widget.endDate); 

		//Initilize all points
		for (var day = widget.startDate; day.isBefore(widget.endDate); day.add(const Duration(days: 1)){
			_emotionData[emotion].add(FlSpot( day.diffrence(widget.startDate).inDays(), 0));     
		}

		//Calculate sum strength for each emotion
		for (var entry in entries){
			for (var emotion in entry.getEmotions()){
				_emotionData[emotion].y += emotion.strength; 
			}
		} 	

		return Container( 
				padding: const EdgeInsets.all(6.0),
				child: switch() {
				GraphTypes.time => LineChart(
					LineChartData(
						minX: 0, maxX: endDate.diffrence(widget.startDate).inDays(),
						minY: 0, maxY: MAX_STRENGTH,
						lineBarsData: [
							//Create a line for each emotion
							data: _emotionData.map((emotion) => {
								return LineChartBarData(
									//Dont plot emotions that dont occur
									show: _emotionData[emotion].any((value) => value > 0),
									spots: _emotionData[emotion],
									color: emotion.getColor(),
									isCurved: true,
									curveSmoothness: 0.35,
								);
							});
						],
					),
				),
				GraphTypes.frequency => null, //TODO
				}
			),
		);
	}
}
