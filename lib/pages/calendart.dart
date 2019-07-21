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

  List<Todo> _tasksToShow = [];

  @override
  void initState() {
    super.initState();
    _tasksToShow = widget.tasks;
    _compute(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TableCalendar(
          locale: 'zh_CN',
          // headerVisible: false,
          headerStyle: HeaderStyle(),
          onDaySelected: (DateTime day, List events) {
            _compute(day);
          },
          // builders: CalendarBuilders(
          //   markersBuilder: (context, date, events, holidays) {
          //       final children = <Widget>[];
          //       if (events.isNotEmpty) {
          //         children.add(
          //           Positioned(
          //             right: 1,
          //             bottom: 1,
          //             child: _buildEventsMarker(date, events),
          //           ),
          //         );
          //       }
          //       return children;
          //   }
          // )
        ),
        Expanded(
          child: _buildTaskListArea(),
          flex: 1,
        ),
      ],
    );
  }

  void _compute(DateTime day) {
    _tasksToShow.clear();
    widget.tasks.forEach((todo) {
      if (todo == null) {
        return;
      }
      if (todo.date != null && todo.date == day) {
        _tasksToShow.add(todo);
      }
    });
    _tasksToShow.sort((a, b) => a.compareWith(b));
    this.setState(() {});
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
