extension Formatter on DateTime {
	static const DATE_ERROR_STRING = 'Date is Wrong';

  // Get the month string
  ({String day, String month, String weekday}) formatDate() {
    return (
			month: switch (month) {
				DateTime.january => 'January',
				DateTime.february => 'February',
				DateTime.march => 'March',
				DateTime.april => 'April',
				DateTime.may => 'May',
				DateTime.june => 'June',
				DateTime.july => 'July',
				DateTime.august  => 'August',
				DateTime.september => 'September',
				DateTime.october =>'October',
				DateTime.november =>'November',
				DateTime.december =>'December',
				_ => DATE_ERROR_STRING, // This should never happen
			},
			weekday: switch (weekday) {
				DateTime.monday => "Monday",
				DateTime.tuesday => "Tuesday",
				DateTime.wednesday => "Wednesday",
				DateTime.thursday => "Thursday",
				DateTime.friday => "Friday",
				DateTime.saturday => "Saturday",
				DateTime.sunday => "Sunday",
				_ => DATE_ERROR_STRING, // This should never happen
			},
			day: switch (day) {
				1 => "1st",
				2 => "2nd",
				3 => "3rd",
				_ when day < 31 => "${day}th",
				31 => "31st",
				_ => DATE_ERROR_STRING, // This should never happen
			},
		);
  }

  // Check if entries are in the same filter date
  bool isSameDate(DateTime other, String display) {
    switch (display) {
      // If week filter, then check if in the same year, month, and week
      case 'Week':
        final firstWeek = DateTime(DateTime.now().year, 1, 1);
        return (year == other.year && month == other.month && (getWeekNumber(firstWeek, this) == getWeekNumber(firstWeek, other)));
      // if month filter, then check for same year and month
      case 'Month': return (year == other.year && month == other.month);
      // if year filter, then check for same year
      case 'Year': return (year == other.year);
      // This should never happen
      default: return false;
    }
  }

  // get the week number for DateTime math in headers and filters
  int getWeekNumber(DateTime start, DateTime end) {
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day);

    // return the difference between the start and end date by week rounded up
    return (end.difference(start).inDays / 7).ceil();
  }
}

