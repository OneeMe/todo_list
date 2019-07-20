class DateTimeFormatter {
  static String stringBaseNow(DateTime dateTime) {
    if (dateTime == null) {
      return '';
    }
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute}';
    }
    if (dateTime.year == now.year) {
      return '${dateTime.month}-${dateTime.day}';
    }
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}


bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameYear(DateTime a, DateTime b) {
  return a.year == b.year;
}