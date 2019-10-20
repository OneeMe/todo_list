import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/components/delete_todo_dialog.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:todo_list/pages/route_url.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key key, this.todoList}) : super(key: key);

  final TodoList todoList;

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();

  void updateData() {
    if (mounted) {
      ChangeInfo info = widget.todoList.value;
      if (info?.type == ChangeInfoType.Insert) {
        _animatedListKey.currentState.insertItem(info.index);
      } else if (info?.type == ChangeInfoType.Init) {
        List.generate(widget.todoList.length, (i) => i).forEach(_animatedListKey.currentState.insertItem);
      }
    }
  }

  @override
  void initState() {
    widget.todoList.addListener(updateData);
    super.initState();
  }

  @override
  void dispose() {
    widget.todoList.removeListener(updateData);
    super.dispose();
  }

  void _onFinished(Todo todo, int index) {
    setState(() {
      widget.todoList.finishedAt(todo.id);
    });
  }

  void _onStar(Todo todo, int index) {
    setState(() {
      widget.todoList.starAt(todo.id);
    });
  }

  void _onTap(Todo todo, int index) async {
    Todo changedTodo = await Navigator.of(context).pushNamed(EDIT_TODO_PAGE_URL, arguments: EditTodoPageArgument(openType: OpenType.Preview, todo: todo));
    if (changedTodo == null) {
      return;
    }
    widget.todoList.updateTodo(todo.id, todo);
  }

  void _onLongPress(Todo todo, int index) async {
    bool result = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteTodoDialog(
            todo: todo,
          );
        }
    );
    if (result) {
      int index = widget.todoList.remove(todo.id);
      _animatedListKey.currentState.removeItem(index, (BuildContext context, Animation<double> animation) => _removedItemBuilder(todo, index, animation));
    }
  }

  Widget _removedItemBuilder(Todo todo, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: _buildTodo(todo, index),
    );
  }

  Widget _buildTodo(Todo todo, int index) {
    return TodoItem(
      todo: todo,
      key: Key(todo.id),
      onFinished: _onFinished,
      onStar: _onStar,
      onTap: _onTap,
      onLongPress: _onLongPress,
      index: index,
    );
  }

  Future<void> _onRefresh() async {
    await widget.todoList.syncWithNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: AnimatedList(
        key: _animatedListKey,
        initialItemCount: widget.todoList.length,
        itemBuilder: (context, index, animation) {
          Todo todo = widget.todoList.list[index];
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: _buildTodo(todo, index),
          );
        },
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo todo, int index) onStar;
  final Function(Todo todo, int index) onFinished;
  final Function(Todo todo, int index) onTap;
  final Function(Todo todo, int index) onLongPress;
  final int index;

  const TodoItem({Key key, this.todo, this.onStar, this.onFinished, this.onTap, this.onLongPress, this.index}) : super(key: key);

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
              onTap: () { onFinished(todo, index); },
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
          onTap: () { onStar(todo, index); },
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
      onTap: () { onTap(todo, index); },
      onLongPress: () => onLongPress(todo, index),
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