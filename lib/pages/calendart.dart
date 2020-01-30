import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.todoList}) : super(key: key);

  final TodoList todoList;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Todo>> _date2TodoMap = {};
  List<Todo> _todosToShow = [];
  CalendarController calendarController;


  void updateData() {
    if (mounted) {
      setState(() {
        _todosToShow.clear();
        _date2TodoMap.clear();
        _initDate2TodoMap();
      });
    }
  }

  @override
  void dispose() {
    widget.todoList.removeListener(updateData);
    calendarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
    _initDate2TodoMap();
    widget.todoList.addListener(updateData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TableCalendar(
          calendarController: calendarController,
          locale: 'zh_CN',
          events: _date2TodoMap,
          headerStyle: HeaderStyle(),
          calendarStyle: CalendarStyle(
            todayColor: Colors.transparent,
            todayStyle: TextStyle(color: Colors.black),
          ),
          onDaySelected: (DateTime day, List events) {
            this.setState(() {
              _todosToShow = events.cast<Todo>();
            });
          },
        ),
        Expanded(
          child: _buildTaskListArea(),
        ),
      ],
    );
  }

  void _initDate2TodoMap() {
    widget.todoList.list.forEach((todo) {
      _date2TodoMap.putIfAbsent(todo.date, () => []);
      _date2TodoMap[todo.date].add(todo);
    });
  }

  Widget _buildTaskListArea() {
    return ListView.builder(
      itemCount: _todosToShow.length,
      itemBuilder: (context, index) {
        Todo todo = _todosToShow[index];
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
}
