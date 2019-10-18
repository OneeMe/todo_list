import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/todo.dart';


typedef RemovedItemBuilder = Widget Function(Todo todo, BuildContext context, Animation<double> animation);
const String DB_NAME = 'todo_list.db';
const String TABLE_NAME = 'todos';

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
    loadFromDataBase();
  }

  List<Todo> _todoList;
  Database _database;

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

  Future<void> loadFromDataBase() async {
    await _initDataBase(createTable: true);
    value = ChangeInfo(null, null, ChangeInfoType.Init);
    List<Map<String, dynamic>> dbRecords = await _database.query(TABLE_NAME);
    List<Todo> result = dbRecords.map((item) => Todo.fromMap(item)).toList();
    if (result.isNotEmpty) {
      _todoList = result;
      _sort();
      notifyListeners();
    }
  }

  Future _initDataBase({bool createTable = false}) async {
    if (_database == null) {
      _database = await openDatabase(DB_NAME, version: 1, onCreate: (Database database, int version) async {
        await database.execute('''
        create table $TABLE_NAME (
          $ID text primary key,
          $TITLE text,
          $DESCRIPTION text,
          $DATE text,
          $START_TIME text,
          $END_TIME text,
          $PRIORITY integer,
          $IS_FINISHED integer,
          $IS_STAR integer,
          $LOCATION_LATITUDE text,
          $LOCATION_LONGITUDE text,
          $LOCATION_DESCRIPTION text
        )
        ''');
      });
    }
  }

   void _add(Todo todo) {
     _todoList.add(todo);
     _sort();
     _database.insert(TABLE_NAME, todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
    _database.delete(TABLE_NAME, where: '$ID = ?', whereArgs: [id]);
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
    _database.update(TABLE_NAME, todo.toMap(), where: '$ID = ?', whereArgs: [id]);
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
    _database.update(TABLE_NAME, todo.toMap(), where: '$ID = ?', whereArgs: [id]);
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
    _database.update(TABLE_NAME, todo.toMap(), where: '$ID = ?', whereArgs: [id]);
    return true;
  }
}
