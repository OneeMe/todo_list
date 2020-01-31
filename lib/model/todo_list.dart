import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/model/db_provider.dart';
import 'package:todo_list/model/network_client.dart';
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

const String EDIT_TIME_KEY = 'todo_list_edit_timestamp';

class TodoList extends ValueNotifier<ChangeInfo> {
  TodoList(this.email) : super(null) {
    _todoList = [];
    _dbProvider = DbProvider(email);
    _networkProvider = NetworkClient.instance();
    _dbProvider.loadFromDataBase().then((List<Todo> todos) async {
      if (todos.isNotEmpty) {
        _todoList = todos;
        _sort();
        value = ChangeInfo(null, null, ChangeInfoType.Init);
        SharedPreferences instance = await SharedPreferences.getInstance();
        if (_editTime == null && instance.containsKey(EDIT_TIME_KEY)) {
          _editTime = DateTime.fromMillisecondsSinceEpoch(instance.getInt(EDIT_TIME_KEY));
        }
      }
    });
  }

  List<Todo> _todoList;
  DbProvider _dbProvider;
  NetworkClient _networkProvider;
  DateTime _editTime;
  DateTime get editTime => _editTime;
  final String email;

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

  @override
  set value(ChangeInfo info) {
    if (info.type != ChangeInfoType.Init) {
      _editTime = DateTime.now();
      SharedPreferences.getInstance().then((SharedPreferences instance) => instance.setInt(EDIT_TIME_KEY, _editTime.millisecondsSinceEpoch));
    }
    super.value = info;
  }

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

  Future<void> syncWithNetwork() async {
    FetchListResult result = await _networkProvider.fetchList(email);
    if (result.error.isEmpty) {
      if (_editTime.isAfter(result.timestamp)) {
        await _networkProvider.uploadList(list, email);
      } else {
        _todoList = result.data;
        value = ChangeInfo(null, null, ChangeInfoType.Init);
      }
    }
  }
}
