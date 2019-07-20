import 'package:flutter/material.dart';
import 'package:todo_list/components/date_filed_wrapper.dart';
import 'package:todo_list/components/labeld_field.dart';
import 'package:todo_list/components/time_filed_wrapper.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/utils/date_time.dart';

class EditTodoPage extends StatefulWidget {
  final EditTodoPageArgument argument;

  const EditTodoPage({Key key, @required this.argument})
      : assert(argument != null),
        super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final FocusNode _taskNameFocusNode = FocusNode();
  final FocusNode _taskDescFocusNode = FocusNode();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final DateFieldController _dateController = DateFieldController();
  final TimeFieldController _startTimeController = TimeFieldController();
  final TimeFieldController _endTimeController = TimeFieldController();
  final TextEditingController _startTimeTextController =
      TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _endTimeTextController = TextEditingController();

  final EdgeInsetsGeometry _padding = const EdgeInsets.fromLTRB(20, 10, 20, 20);
  final TextStyle _titleStyle =
      TextStyle(color: Color(0xFF1D1D26), fontFamily: 'Avenir', fontSize: 14.0);
  final InputBorder _border = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 0.5));

  OpenType _openType;
  Todo _todo;

  Map<OpenType, OpenTypeConfig> _openTypeConfigMap;

  void _edit() {
    setState(() {
      _openType = OpenType.Edit;
    });
  }

  void _submit() {
    Navigator.of(context).pop();
  }

  void _save() {}

  @override
  void initState() {
    super.initState();
    _openType = widget.argument.openType;
    _todo = widget.argument.todo;
    _openTypeConfigMap = {
      OpenType.Preview: OpenTypeConfig('查看 TODO', Icons.edit, _edit),
      OpenType.Edit: OpenTypeConfig('编辑 TODO', Icons.check, _submit),
      OpenType.Add: OpenTypeConfig('添加 TODO', Icons.check, _save),
    };
    _dateController.addListener(() {
      _dateTextController.text = formatAsChineseDate(_dateController.date);
    });
    _startTimeController.addListener(() {
      _startTimeTextController.text =
          formatTimeOfDay(_startTimeController.time);
    });
    _endTimeController.addListener(() {
      _endTimeTextController.text = formatTimeOfDay(_endTimeController.time);
    });
    if (_openType == OpenType.Preview) {
      _taskNameController.text = _todo.title;
      _taskDescController.text = _todo.description;
      _dateController.date = _todo.date;

      _startTimeController.time = _todo.startTime;
      _endTimeController.time = _todo.endTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_openTypeConfigMap[_openType].title),
        backgroundColor: BACKGROUND_COLOR,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _openTypeConfigMap[_openType].icon,
              color: Color(0xffbbbbbe),
            ),
            onPressed: _openTypeConfigMap[_openType].onPressed,
          ),
        ],
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: _openType == OpenType.Preview ? true : false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              _buildInputTextLine('名称', '任务名称', _taskNameFocusNode,
                  maxLines: 1, controller: _taskNameController),
              _buildInputTextLine('描述', '任务描述', _taskDescFocusNode,
                  controller: _taskDescController),
              _buildDatePicker(
                  '日期', '请选择日期', _dateController, _dateTextController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _buildTimePicker('开始时间', '请选择开始时间',
                        _startTimeController, _startTimeTextController),
                  ),
                  Expanded(
                    child: _buildTimePicker('终止时间', '请选择终止时间',
                        _endTimeController, _endTimeTextController),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputTextLine(String title, String hintText, FocusNode focusNode,
      {int maxLines, TextEditingController controller}) {
    TextInputType inputType =
        maxLines == null ? TextInputType.multiline : TextInputType.text;
    return LabeledField(
      labelText: title,
      labelStyle: _titleStyle,
      padding: _padding,
      child: TextField(
        keyboardType: inputType,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: _border,
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      String title,
      String hintText,
      DateFieldController dateController,
      TextEditingController textController) {
    DateTime now = DateTime.now();
    return LabeledField(
      labelText: title,
      labelStyle: _titleStyle,
      padding: _padding,
      child: DateFieldWrapper(
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            disabledBorder: _border,
          ),
          enabled: false,
        ),
        controller: dateController,
        initialDate: now,
        firstDate: DateTime(now.year, now.month, now.day - 1),
        lastDate: DateTime(2025),
      ),
    );
  }

  Widget _buildTimePicker(
      String title,
      String hintText,
      TimeFieldController timeController,
      TextEditingController textController) {
    return LabeledField(
      labelText: title,
      labelStyle: _titleStyle,
      padding: _padding,
      child: TimeFieldWrapper(
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            disabledBorder: _border,
          ),
          enabled: false,
        ),
        controller: timeController,
        initialTime: TimeOfDay.now(),
      ),
    );
  }
}

class OpenTypeConfig {
  final String title;
  final IconData icon;
  final Function onPressed;

  const OpenTypeConfig(this.title, this.icon, this.onPressed);
}
