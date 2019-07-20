import 'package:todo_list/model/todo.dart';

const LOGIN_PAGE_URL = '/';
const REGISTER_PAGE_URL = '/register';
const TODO_ENTRY_PAGE_URL = '/entry';
const EDIT_TODO_PAGE_URL = '/add';

enum OpenType {
  Add,
  Edit,
  Preview,
}

class EditTodoPageArgument {
  final OpenType openType;
  final Todo todo;

  EditTodoPageArgument({this.openType, this.todo});
}
