import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/model/todo.dart';

class CalendarPage extends StatefulWidget {
  final List<Todo> tasks;

  CalendarPage({Key key, this.tasks}): assert(tasks != null), super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  Map<DateTime, List<Todo>> _visibleEvents;
  List<Todo> _tasksToShow = [];

  @override
  void initState() {
    super.initState();
    _compute();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TableCalendar(
          locale: 'zh_CN',
          // headerVisible: false,
          events: _visibleEvents,
          headerStyle: HeaderStyle(),
          calendarStyle: CalendarStyle(
            todayColor: Colors.transparent,
            todayStyle: TextStyle(color: Colors.black)
          ),
          onDaySelected: (DateTime day, List events) {
            this.setState(() {
              _tasksToShow = events;
            });
          },
        ),
        Expanded(
          child: _buildTaskListArea(),
          flex: 1,
        ),
      ],
    );
  }

  void _compute() {
    _visibleEvents = {};
    widget.tasks.forEach((todo) {
      if (todo == null) {
        return;
      }
      List<Todo> value = _visibleEvents[todo.date];
      if (value == null) {
        value = [];
        _visibleEvents[todo.date] = value; 
      }
      value.add(todo);
    });
  }

  Widget _buildTaskListArea() {
    return ListView.builder(
      itemCount: _tasksToShow.length,
      itemBuilder: (context, index) {
        Todo task = _tasksToShow[index];
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(color: task.status.color, height: 10, width: 10, margin: EdgeInsets.all(10),),
                Text(task.title),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time, size: 15, color: Color(0xffb9b9bc),),
                  Text(' ${task.startTime.hour} - ${task.endTime.hour}', style: TextStyle(color: Color(0xffb9b9bc))),
                ],
              ),
            ),
            Container(height: 1, color: Color(0xffececed), margin: EdgeInsets.fromLTRB(0, 20, 0, 20),)
          ],
        );
      }
    );
  }
}
