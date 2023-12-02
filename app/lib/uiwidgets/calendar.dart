import 'package:flutter/material.dart';

import 'package:app/provider/entry.dart';

import 'package:app/helper/dates_and_times.dart';
import 'package:app/provider/settings.dart' as settings;

import 'package:app/pages/entries.dart';


class Calendar extends StatefulWidget {
	const Calendar({super.key});

	@override
	State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
	DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1); 
	DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

	List<({int strength, Color? color, bool border})> _emotionData = [];

	int _daysFromDate(DateTime day) => day.difference(startDate).inDays;
	DateTime _getLastOfTheMonth(DateTime date) =>  DateTime(date.year, date.month + 1, 1).subtract(const Duration(days: 1));


	///Displays a given day of the month in a container with the color set 
	///according to the strongest emotion of that day (if any)
	Widget _displayDay(day, {outOfRange = false}) => GestureDetector(
		onTap: () => Navigator.of(context).push(EntryPanelPage.route(targetDate: startDate.add(Duration(days: day)))),
		child: Container(
			key: const Key("Calendar_Day"),
			alignment: Alignment.center,
			margin: const EdgeInsets.all(4.0),
			decoration: ShapeDecoration(
				color: outOfRange ? Colors.transparent : _emotionData[day].color, 
				shape: CircleBorder(
					//Only show border if there is a plan on that day
					side: BorderSide( 
						style: !outOfRange && _emotionData[day].border ? BorderStyle.solid : BorderStyle.none, 
						width: 2.5,
					) 
				),
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
		final startFirstWeek = startDate.subtract(Duration(days: startDate.weekday));
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
		_emotionData = List.filled(_daysFromDate(endDate) +1, (strength: 0, color: null, border: false));
		for (var entry in entriesInDateRange(startDate, endDate).toList()) {
			final strongestEmotion = entry.getStrongestEmotion();

			//Color each day according to the strongest emotion, leave null if no emotions are tagged 
			if (   _emotionData[_daysFromDate(entry.date)].color == null 
				  || strongestEmotion.strength > _emotionData[_daysFromDate(entry.date)].strength) {
				_emotionData[_daysFromDate(entry.date)] = (
					strength: strongestEmotion.strength,
					color: strongestEmotion.color,
					border: false,
				);
			}
		}
	
		//Find any plans in date range and add border
		for (var plan in plansInDateRange(startDate, endDate)) {
			final datapoint = _emotionData[_daysFromDate(plan.date)];
			_emotionData[_daysFromDate(plan.date)] = (
					strength: datapoint.strength,
					color: datapoint.color,
					border: true,
			);
		}

		return Card(
			key: const Key("Calendar_Panel"),
			child: Column(
				children: [
					//Calendar title and time range changerj
					Container(
						margin: const EdgeInsets.only(top: 13) + const EdgeInsets.symmetric(horizontal: 14),
						child: Row( 
							children: [
								IconButton(
									key: const Key("Date_Previous"),
									icon: const Icon( Icons.navigate_before, ),
									onPressed: ()=> setState(() {
										endDate = startDate.subtract(const Duration(days: 1));
										startDate = DateTime(endDate.year, endDate.month, 1);
									}),
								),
								Expanded( 
									child: Text(
										startDate.formatDate().month 
										//Add year if nessicary
										+ ((startDate.year != DateTime.now().year) ? " ${startDate.year}" : ""), 
										style: settings.getCurrentTheme().textTheme.titleLarge,
										textAlign: TextAlign.center,
									), 
								),
								IconButton(
									key: const Key("Date_Next"),
									icon: const Icon( Icons.navigate_next, ),
									onPressed: ()=> setState(() {
										startDate = endDate.add(const Duration(days: 1));
										endDate = _getLastOfTheMonth(startDate);
									}),
								),
							]
						),
					),
					const Divider(),
					//Weekday header
					Row( 
						children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((weekday) {
							return Expanded( 
								child: Text( weekday, textAlign: TextAlign.center)
							);
						}).toList(),
					),
					//Calendar grid
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
