import 'package:flutter/material.dart';

String formatAsChineseDate(DateTime dateTime) {
  if (dateTime == null) {
    return '';
  }
  return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  if (timeOfDay == null) {
    return '';
  }
  return '${timeOfDay.hour}:${timeOfDay.minute}';
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameYear(DateTime a, DateTime b) {
  return a.year == b.year;
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}