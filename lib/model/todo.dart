import 'package:flutter/material.dart';
import 'package:todo_list/utils/date_time.dart';
import 'package:uuid/uuid.dart';

class Todo {
  /// ID
  final String id;
  /// 标题
  String title;
  /// 描述
  String description;
  /// 日期
  DateTime date;
  /// 开始时间
  TimeOfDay startTime;
  /// 结束时间
  TimeOfDay endTime;
  /// 优先级
  Priority priority;
  /// 提醒时间
  Duration notifyTime;
  /// 是否完成
  bool isFinished;
  /// 是否星标任务
  bool isStar;

  Todo({
    String id,
    this.title = "",
    this.description = "",
    this.date,
    this.startTime = const TimeOfDay(hour: 0, minute: 0),
    this.endTime = const TimeOfDay(hour: 0, minute: 0),
    this.priority = Priority.Unspecificed, // 优先级越小优先级越高
    this.notifyTime = const Duration(),
    this.isFinished = false,
    this.isStar = false,
  }) : this.id = id ?? generateNewId() {
    // 如果开始时间为空，则设置为当前时间
    if (date == null) {
      date = today();
    }
  }

  static Uuid _uuid = Uuid();

  static String generateNewId() => _uuid.v1();

  String get timeString {
    DateTime now = DateTime.now();
    if (isSameDay(now, date)) {
      return '${date.hour}:${date.minute} - ${endTime.hour}:${endTime.minute}';
    }
    return '${date.year}/${date.month}/${date.day}';
  }

  int compareWith(Todo todo) {
    if (this.isFinished && !todo.isFinished) {
      return 1;
    }
    if (!this.isFinished && todo.isFinished) {
      return -1;
    }
    if (!this.isStar && todo.isStar) {
      return 1;
    }
    if (this.isStar && !todo.isStar) {
      return -1;
    }
    int dateCompareResult = todo.date.compareTo(this.date);
    if (dateCompareResult != 0) {
      return dateCompareResult;
    }
    return endTime.hour - todo.endTime.hour;
  }
}

enum Priority {
  Unspecificed,
  Low,
  Medium,
  High,
}