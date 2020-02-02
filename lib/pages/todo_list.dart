import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/components/delete_todo_dialog.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:tuple/tuple.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key key}) : super(key: key);

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Selector<TodoList, Tuple2<TodoList, ChangeInfo>>(
      shouldRebuild: (_, Tuple2<TodoList, ChangeInfo> tuple) {
        if (tuple.item2?.type == ChangeInfoType.Insert) {
          _animatedListKey.currentState.insertItem(tuple.item2.index);
        } else if (tuple.item2?.type == ChangeInfoType.Init) {
          List.generate(tuple.item1.length, (i) => i)
              .forEach(_animatedListKey.currentState.insertItem);
        } else {
          return true;
        }
        return false;
      },
      selector: (_, TodoList todoList) => Tuple2<TodoList, ChangeInfo>(todoList, todoList.value),
      builder: (BuildContext context, Tuple2<TodoList, ChangeInfo> tuple, Widget child) {
        return RefreshIndicator(
          onRefresh: () => tuple.item1.syncWithNetwork(),
          child: AnimatedList(
            key: _animatedListKey,
            initialItemCount: tuple.item1.length,
            itemBuilder: (context, index, animation) {
              Todo todo = tuple.item1.list[index];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: TodoItem(todo: todo),
              );
            },
          ),
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({Key key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle descTextStyle = TextStyle(
      color: Color.fromARGB(255, 74, 74, 74),
      fontSize: 15,
      fontFamily: 'Avenir',
      decoration:
          todo.isFinished ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: Color.fromARGB(255, 74, 74, 74),
    );
    Widget infoRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Provider.of<TodoList>(context, listen: false).finishedAt(todo.id);
              },
              child: Image.asset(
                todo.isFinished
                    ? 'assets/images/rect_selected.png'
                    : 'assets/images/rect.png',
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
          onTap: () {
            Provider.of<TodoList>(context, listen: false).starAt(todo.id);
          },
          child: Container(
            child: Image.asset(todo.isStar
                ? 'assets/images/star.png'
                : 'assets/images/star_normal.png'),
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
      onTap: () async {
        Todo changedTodo = await Navigator.of(context).pushNamed(
            EDIT_TODO_PAGE_URL,
            arguments:
                EditTodoPageArgument(openType: OpenType.Preview, todo: todo));
        if (changedTodo == null) {
          return;
        }
        Provider.of<TodoList>(context, listen: false)
            .updateTodo(changedTodo.id, changedTodo);
      },
      onLongPress: () async {
        bool result = await showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteTodoDialog(
                todo: todo,
              );
            });
        if (result) {
          int index =
              Provider.of<TodoList>(context, listen: false).remove(todo.id);
          AnimatedList.of(context).removeItem(index,
              (BuildContext context, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: TodoItem(todo: todo),
            );
          });
        }
      },
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
