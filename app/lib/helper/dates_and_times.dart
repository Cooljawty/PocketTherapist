//Months

//Weekdays
const weekday = {
	DateTime.monday: "Monday",
	DateTime.tuesday: "Tuesday",
	DateTime.wednesday: "Wednesday",
	DateTime.thursday: "Thursday",
	DateTime.friday: "Friday",
	DateTime.saturday: "Saturday",
	DateTime.sunday: "Sunday",
};

extension Formatter on DateTime {
  // Get the month string
  String formatDate() {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return 'Date is Wrong'; // This should never happen
    }
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

