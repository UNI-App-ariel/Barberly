class MyDateUtils {
  static bool isSameDate(DateTime date, DateTime other) {
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  static DateTime getCanonicalTime(DateTime time) {
    return DateTime(0, 0, 0, time.hour, time.minute);
  }

  static bool isSameTime(DateTime a, DateTime b) {
    return getCanonicalTime(a) == getCanonicalTime(b);
  }

  static String toDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time to HH:mm
  static String toTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Fromat datetime to HH:mm dd/MM/yyyy
  static String toDateTimeString(DateTime date) {
    return '${toDate(date)} ${toTime(date)}';
  }

  // Get day int from DateTime. 1 is Sunday, 7 is Saturday.
  static int getDayInt(DateTime date) {
    return date.weekday == DateTime.sunday ? 1 : date.weekday + 1;
  }

  // Get day name from int value. 1 is Sunday, 7 is Saturday.
  static String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Sunday';
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thursday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      default:
        return '';
    }
  }

  static int sundayN = 1;
  static int mondayN = 2;
  static int tuesdayN = 3;
  static int wednesdayN = 4;
  static int thursdayN = 5;
  static int fridayN = 6;
  static int saturdayN = 7;


  /// Get the canonical date of today
  /// 
  /// This method returns a new [DateTime] object with the same year, month and day as today's date.
  static DateTime getCanonicalToday() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }
}