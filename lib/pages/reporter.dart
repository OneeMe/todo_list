import 'package:flutter/material.dart';
import 'package:todo_list/components/empty_widget.dart';
import 'package:todo_list/components/scroll_option_view.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';

final List<String> months = [
  '1月',
  '2月',
  '3月',
  '4月',
  '5月',
  '6月',
  '7月',
  '8月',
  '9月',
  '10月',
  '11月',
  '12月',
];

class ReporterPage extends StatefulWidget {
  ReporterPage({Key key, this.todoList}) : super(key: key);

  final TodoList todoList;

  @override
  _ReporterPageState createState() => _ReporterPageState();
}

class _ReporterPageState extends State<ReporterPage> {
  int _finishedTodoCount = 0;
  int _delayedTodoCount = 0;

  List<Todo> _todosOfThisMonth = [];

  int currentMonth = 1;

  @override
  void initState() {
    super.initState();
    _initTodosOfThisMonth();
    widget.todoList.addListener(() {
      setState(() {
        _reset();
        _initTodosOfThisMonth();
      });
    });
  }

  void _reset() {
    _finishedTodoCount = 0;
    _delayedTodoCount = 0;
    _todosOfThisMonth.clear();
  }

  /// month: [1..12]
  void _initTodosOfThisMonth() {
    widget.todoList.list.forEach((todo) {
      if (todo.date != null && todo.date.month == currentMonth) {
        _todosOfThisMonth.add(todo);
        TodoStatus status = todo.status;
        if (status == TodoStatus.finished) {
          _finishedTodoCount += 1;
        }
        if (status == TodoStatus.delay) {
          _delayedTodoCount += 1;
        }
      }
    });
    _todosOfThisMonth.sort((a, b) => a.compareWith(b));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
            child: ScrollOptionView(
              options: months,
              onOptionChanged: (context, option, index) {
                this.setState(() {
                  currentMonth = index + 1;
                  _reset();
                  _initTodosOfThisMonth();
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildAllTodoStatusArea(),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildColouredStripeArea(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildTodoListArea(), flex: 1),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAllTodoStatusArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildTodoStatusView(TodoStatus.finished, _finishedTodoCount),
        _buildTodoStatusView(TodoStatus.delay, _delayedTodoCount),
      ],
    );
  }

  Widget _buildColouredStripeArea() {
    int sum = _finishedTodoCount + _delayedTodoCount;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildColouredStripe(
              _finishedTodoCount / sum, const Color(0xff51d2c2)),
          _buildColouredStripe(
              _delayedTodoCount / sum, const Color(0xffffb258)),
        ],
      ),
    );
  }

  Widget _buildTodoListArea() {
    return ListView.builder(
      itemCount: _todosOfThisMonth.length,
      itemBuilder: (context, index) {
        Todo todo = _todosOfThisMonth[index];
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  color: todo.status.color,
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.all(10),
                ),
                Text(todo.title),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 15,
                    color: Color(0xffb9b9bc),
                  ),
                  Text(' ${todo.startTime.hour} - ${todo.endTime.hour}',
                      style: TextStyle(color: Color(0xffb9b9bc))),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color(0xffececed),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            )
          ],
        );
      },
    );
  }

  Widget _buildColouredStripe(double percentage, Color color) {
    if (percentage == null || percentage < 0 || percentage.isNaN) {
      return EmptyWidget();
    }
    return SizedBox(
      height: 10,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
        ),
      ),
    );
  }

  Widget _buildTodoStatusView(TodoStatus status, int count) {
    if (status == null) {
      status = TodoStatus.unspecified;
    }
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Text(status.description, style: TextStyle(fontSize: 16)),
          Text(count.toString(), style: TextStyle(fontSize: 33)),
          Container(
            color: status.color,
            height: 10,
            width: 10,
            margin: EdgeInsets.all(10),
          )
        ],
      ),
    );
  }
}
