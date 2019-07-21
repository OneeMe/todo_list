import 'package:flutter/material.dart';
import 'package:todo_list/components/scroll_option_view.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/utils/utils.dart';

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

  final List<Todo> tasks;

  ReporterPage({Key key, this.tasks}): assert(tasks != null), super(key: key);

  @override
  _ReporterPageState createState() => _ReporterPageState();
}

class _ReporterPageState extends State<ReporterPage> {
  int _finishedTaskCount = 64;
  int _handlingTaskCount = 32;
  int _delayedTaskCount = 12;

  List<Todo> _tasksOfThisMonth = [];
  List<Todo> _tasksToShow = [];

  TaskStatus _showedStatus;

  @override
  void initState() {
    super.initState();
    _compute(1);
  }

  void _reset() {
    _finishedTaskCount = 0;
    _handlingTaskCount = 0;
    _delayedTaskCount = 0;
    _tasksOfThisMonth.clear();
    _tasksToShow = null;
    _showedStatus = null;
  }

  /// month: [1..12]
  void _compute(int month) {
    _reset();
    widget.tasks.forEach((todo) {
      if (todo == null) {
        return;
      }
      if (todo.date != null && todo.date.month == month) {
        _tasksOfThisMonth.add(todo);
        TaskStatus status = todo.status;
        if (status == TaskStatus.finished) {
          _finishedTaskCount += 1;
        }
        if (status == TaskStatus.handling) {
          _handlingTaskCount += 1;
        }
        if (status == TaskStatus.delay) {
          _delayedTaskCount += 1;
        }
      }
    });
    _tasksOfThisMonth.sort((a, b) => a.compareWith(b));
    _computeByTaskStatus(null);
    this.setState(() {});
  }

  void _computeByTaskStatus(TaskStatus status) {
    if (_showedStatus == status && _tasksToShow != null) {
      return;
    }
    if (status == null) {
      _tasksToShow = _tasksOfThisMonth;
    } else {
      _tasksToShow = _tasksOfThisMonth.where((t) => t.status == status).toList();
    }
    this.setState(() {
      _showedStatus = status;
    });
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
                this._compute(index + 1);
              },
            )
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildAllTaskStatusArea()
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildColouredStripeArea()
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildTaskListArea(), flex: 1),
                ],
              ),
            )
          )
        ],
      )
    );
  }

  Widget _buildAllTaskStatusArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildTaskStatusView(TaskStatus.finished, _finishedTaskCount),
        _buildTaskStatusView(TaskStatus.handling, _handlingTaskCount),
        _buildTaskStatusView(TaskStatus.delay, _delayedTaskCount),
      ],
    );
  }

  Widget _buildColouredStripeArea() {
    int sum = _finishedTaskCount + _handlingTaskCount + _delayedTaskCount;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildColouredStripe(_finishedTaskCount / sum, const Color(0xff51d2c2)),
          _buildColouredStripe(_handlingTaskCount / sum, const Color(0xff8c88ff)),
          _buildColouredStripe(_delayedTaskCount / sum, const Color(0xffffb258)),
        ],
      )
    );
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

  Widget _buildColouredStripe(double percentage, Color color) {
    if (percentage == null || percentage < 0 || percentage.isNaN) {
      return EmptyWidget();
    }
    return SizedBox(
      height: 10,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: DecoratedBox(decoration: BoxDecoration(color: color),),
      ),
    );
  }

  Widget _buildTaskStatusView(TaskStatus status, int count) {
    if (status == null) {
      status = TaskStatus.handling;
    }
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(
          color: _showedStatus == status ? Colors.lightGreen : Colors.transparent,
          child: Column(
            children: <Widget>[
              Text(status.description, style: TextStyle(fontSize: 16)),
              Text(count.toString(), style: TextStyle(fontSize: 33)),
              Container(color: status.color, height: 10, width: 10, margin: EdgeInsets.all(10),)
            ],
          )
        ),
        onTap: () {
          _computeByTaskStatus(status == _showedStatus ? null : status);
        },
      )
    );
  }
}
