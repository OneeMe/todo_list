import 'package:todo_list/model/todo.dart';

class TodoList {
  final List<Todo> _todoList;

  TodoList(this._todoList) {
    _sort();
  }

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

  void add(Todo todo) {
    _todoList.add(todo);
    _sort();
  }

  void remove(String id) {
    _todoList.removeWhere((todo) => todo.id == id);
  }

  void _sort() {
    _todoList.sort((a, b) => a.compareWith(b));
  }

  Todo find(String id) {
    int index = _todoList.indexWhere((todo) => todo.id == id);
    return index >= 0 ? _todoList[index] : null;
  }

  bool finshedAt(String id) {
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
    return true;
  }

  bool updateTodo(String id, Todo todo) {
    Todo oldTodo = find(id);
    if (oldTodo == null) {
      return false;
    }
    _todoList.remove(oldTodo);
    add(todo);
    return true;
  }
}
