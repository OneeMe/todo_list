import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/components/delete_todo_dialog.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/utils/generate_todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key key}) : super(key: key);

  @override
  TodoListPageState createState() => TodoListPageState(generateTodos(5));
}

class TodoListPageState extends State<TodoListPage> {
  final List<Todo> _todoList;

  TodoListPageState(this._todoList);

  @override
  void initState() {
    super.initState();
    _sortTodoList();
  }

  void _sortTodoList() {
    _todoList.sort((a, b) => a.compareWith(b));
  }

  void insertTodo(Todo todo) {
    setState(() {
      _todoList.insert(0, todo);
      _sortTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return TodoItem(
          todo: _todoList[index],
          key: Key(_todoList[index].id),
          onFinished: (Todo todo) {
            setState(() {
              todo.isFinished = !todo.isFinished;
              _sortTodoList();
            });
          },
          onStar: (Todo todo) {
            setState(() {
              todo.isStar = !todo.isStar;
              _sortTodoList();
            });
          },
          onTap: (Todo todo) async {
            Todo changedTodo = await Navigator.of(context).pushNamed(EDIT_TODO_PAGE_URL, arguments: EditTodoPageArgument(openType: OpenType.Preview, todo: todo));
            if (changedTodo == null) {
              return;
            }
            int oldTodoIndex = _todoList.indexOf(todo);
            _todoList.removeAt(oldTodoIndex);
            insertTodo(changedTodo);
          },
          onLongPress: (Todo todo) async {
            bool result = await showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteTodoDialog(
                  todo: todo,
                );
              }
            );
            if (result) {
              setState(() {
                _todoList.remove(todo);
              });
            }
          },
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo todo) onStar;
  final Function(Todo todo) onFinished;
  final Function(Todo todo) onTap;
  final Function(Todo todo) onLongPress;

  const TodoItem({Key key, this.todo, this.onStar, this.onFinished, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle descTextStyle = TextStyle(
      color: Color.fromARGB(255, 74, 74, 74),
      fontSize: 15,
      fontFamily: 'Avenir',
      decoration: todo.isFinished ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: Color.fromARGB(255, 74, 74, 74),
    );
    Widget infoRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () { onFinished(todo); },
              child: Image.asset(
                todo.isFinished ? 'assets/images/rect_selected.png' : 'assets/images/rect.png',
                width: 25,
                height: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                todo.title,
                style: descTextStyle,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () { onStar(todo); },
          child: Container(
            child: Image.asset(todo.isStar ? 'assets/images/star.png' : 'assets/images/star_normal.png'),
            width: 25,
            height: 25,
          ),
        ),
      ],
    );
    Widget timeRow = Row(
      children: <Widget>[
        Image.asset(
          'assets/images/group.png',
          width: 25.0,
          height: 25.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            todo.timeString,
            style: descTextStyle,
          ),
        )
      ],
    );
    return GestureDetector(
      onTap: () { onTap(todo); },
      onLongPress: () => onLongPress(todo),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 2,
              color: todo.priority.color,
            ),
          ),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            infoRow,
            timeRow,
          ],
        ),
      ),
    );
  }
}