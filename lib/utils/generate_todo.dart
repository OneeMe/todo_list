import 'package:mock_data/mock_data.dart';
import 'package:todo_list/model/todo.dart';

List<Todo> generateTodos(int length) {
  List<Priority> priorities = [
    Priority.Unspecificed,
    Priority.Low,
    Priority.Medium,
    Priority.High,
  ];
  return List.generate(length, (i) {
    DateTime fromTime = mockDate(DateTime(2019, 1, 1));
    DateTime endTime = fromTime.add(Duration(hours: mockInteger(1, 9)));
    return Todo(
      title: '${mockName()} - ${mockString()}',
      priority: priorities[mockInteger(0, 3)],
      description: mockString(30),
      startTime: fromTime,
      endTime: endTime,
      isFinished: mockBool(),
      isStar: mockBool(),
    );
  });
}

bool mockBool() {
  return mockInteger(0, 1) > 0;
}