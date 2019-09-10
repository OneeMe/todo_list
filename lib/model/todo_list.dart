import 'package:flutter/widgets.dart';
import 'package:todo_list/model/todo.dart';

typedef RemovedItemBuilder = Widget Function(Todo todo, BuildContext context, Animation<double> animation);

class TodoList with ChangeNotifier {
  final List<Todo> _todoList;

  TodoList(this._todoList) {
    _sort();
  }

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

   void _add(Todo todo) {
     _todoList.add(todo);
     _sort();
   }

  void add(Todo todo) {
    _add(todo);
    notifyListeners();
  }

  int remove(String id) {
    Todo todo = find(id);
    int index = _todoList.indexOf(todo);
    if (index > _todoList.length) {
      return -1;
    }
    _todoList.removeAt(index);
    notifyListeners();
    return index;
  }

  void _sort() {
    _todoList.sort((a, b) => a.compareWith(b));
  }

  Todo find(String id) {
    int index = _todoList.indexWhere((todo) => todo.id == id);
    return index >= 0 ? _todoList[index] : null;
  }

  bool finishedAt(String id) {
    Todo todo = find(id);
    if (todo == null) {
      return false;
    }
    todo.isFinished = !todo.isFinished;
    _sort();
    return true;
  }

  bool starAt(String id) {
    Todo todo = find(id);
    if (todo == null) {
      return false;
    }
    todo.isStar = !todo.isStar;
    _sort();
    notifyListeners();
    return true;
  }

  bool updateTodo(String id, Todo todo) {
    Todo oldTodo = find(id);
    if (oldTodo == null) {
      return false;
    }
    _todoList.remove(oldTodo);
    _add(todo);
    notifyListeners();
    return true;
  }
}
