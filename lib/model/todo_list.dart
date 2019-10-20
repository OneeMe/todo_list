import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/model/db_provider.dart';
import 'package:todo_list/model/login_status.dart';
import 'package:todo_list/model/todo.dart';

typedef RemovedItemBuilder = Widget Function(
    Todo todo, BuildContext context, Animation<double> animation);

enum ChangeInfoType {
  Delete,
  Insert,
  Update,
  Init,
}

class ChangeInfo {
  final Todo todo;
  final int index;
  final ChangeInfoType type;

  ChangeInfo(this.todo, this.index, this.type);
}

class TodoList extends ValueNotifier<ChangeInfo> {
  TodoList() : super(null) {
    _todoList = [];
    value = ChangeInfo(null, null, ChangeInfoType.Init);
    LoginStatus.instance().loginEmail().then((String email) async {
      _dbProvider = DbProvider(email);
      List<Todo> todos = await _dbProvider.loadFromDataBase();
      if (todos.isNotEmpty) {
        _todoList = todos;
        _sort();
        notifyListeners();
      }
    });
  }

  List<Todo> _todoList;
  DbProvider _dbProvider;

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

  void _add(Todo todo) {
    _todoList.add(todo);
    _sort();
    _dbProvider.add(todo);
  }

  void add(Todo todo) {
    _add(todo);
    value = ChangeInfo(todo, _todoList.indexOf(todo), ChangeInfoType.Insert);
  }

  int remove(String id) {
    Todo todo = find(id);
    int index = _todoList.indexOf(todo);
    if (index > _todoList.length) {
      return -1;
    }
    _todoList.removeAt(index);
    value = ChangeInfo(todo, index, ChangeInfoType.Delete);
    _dbProvider.remove(todo);
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
    value = ChangeInfo(todo, _todoList.indexOf(todo), ChangeInfoType.Update);
    _sort();
    _dbProvider.update(todo);
    return true;
  }

  bool starAt(String id) {
    Todo todo = find(id);
    if (todo == null) {
      return false;
    }
    todo.isStar = !todo.isStar;
    value = ChangeInfo(todo, _todoList.indexOf(todo), ChangeInfoType.Update);
    _sort();
    _dbProvider.update(todo);
    return true;
  }

  bool updateTodo(String id, Todo todo) {
    Todo oldTodo = find(id);
    if (oldTodo == null) {
      return false;
    }
    value = ChangeInfo(todo, _todoList.indexOf(todo), ChangeInfoType.Update);
    _todoList.remove(oldTodo);
    _add(todo);
    _dbProvider.update(todo);
    return true;
  }
}
