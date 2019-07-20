import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/utils/generate_todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState(generateTodos(100));
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Todo> todoList;

  _TodoListPageState(this.todoList);

  @override
  void initState() {
    super.initState();
    todoList.sort((a, b) => a.compareWith(b));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        return TodoItem(
          todo: todoList[index],
        );
      },
    );
  }
}

const Map<Priority, Color> PRIORITY_COLOR = {
  Priority.Unspecificed: Colors.transparent,
  Priority.Low: Color.fromARGB(255, 80, 210, 194),
  Priority.Medium: Color.fromARGB(255, 251, 156, 53),
  Priority.High: Color.fromARGB(255, 228, 74, 77),
};

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({Key key, this.todo}) : super(key: key);

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
            Image.asset(
              todo.isFinished ? 'assets/images/rect_selected.png' : 'assets/images/rect.png',
              width: 25,
              height: 25,
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
        Container(
          child: Image.asset(todo.isStar ? 'assets/images/star.png' : 'assets/images/star_normal.png'),
          width: 25,
          height: 25,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 2,
            color: PRIORITY_COLOR[todo.priority],
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
    );
  }
}