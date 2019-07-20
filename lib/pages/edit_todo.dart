import 'package:flutter/material.dart';
import 'package:todo_list/pages/route_url.dart';

class EditTodoPage extends StatelessWidget {
  final EditTodoPageArgument argument;
  final Map<OpenType, String> _titleMap = const {
    OpenType.Preview: '查看 TODO',
    OpenType.Edit: '编辑 TODO',
    OpenType.Add: '添加 TODO',
  };

  const EditTodoPage({Key key, @required this.argument}) : assert(argument != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleMap[argument.openType]),
        centerTitle: true,
      ),
      body: Center(
        child: Text(this.runtimeType.toString()),
      ),
    );
  }
}