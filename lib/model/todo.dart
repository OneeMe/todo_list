import 'package:todo_list/utils/date_time.dart';
import 'package:uuid/uuid.dart';

class Todo {
  /// ID
  final String id;
  /// 标题
  String title;
  /// 描述
  String description;
  /// 开始时间
  DateTime startTime;
  /// 结束时间
  DateTime endTime;
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
    this.startTime,
    this.endTime,
    this.priority = Priority.Unspecificed, // 优先级越小优先级越高
    this.notifyTime = const Duration(),
    this.isFinished = false,
    this.isStar = false,
  }) : this.id = id ?? generateNewId() {
    // 如果开始时间为空，则设置为当前时间
    if (startTime == null) {
      startTime = DateTime.now();
    }
    if (endTime == null) {
      endTime = startTime;
    }
  }

  static Uuid _uuid = Uuid();

  static String generateNewId() => _uuid.v1();

  String get timeString {
    DateTime now = DateTime.now();
    if (isSameDay(now, startTime) && isSameDay(now, endTime)) {
      return '${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}';
    }
    return '${endTime.year}/${endTime.month}/${endTime.day}';
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
    return todo.endTime.compareTo(this.endTime);
  }
}

enum Priority {
  Unspecificed,
  Low,
  Medium,
  High,
}