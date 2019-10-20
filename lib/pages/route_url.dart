import 'package:todo_list/model/todo.dart';

const LOGIN_PAGE_URL = '/';
const REGISTER_PAGE_URL = '/register';
const TODO_ENTRY_PAGE_URL = '/entry';
const EDIT_TODO_PAGE_URL = '/add';
const LOCATION_DETAIL_PAGE_URL = '/location_detail';

enum OpenType {
  Add,
  Edit,
  Preview,
}

class TodoEntryPageArgument {
  final String email;

  TodoEntryPageArgument({this.email});
}

class EditTodoPageArgument {
  final OpenType openType;
  final Todo todo;

  EditTodoPageArgument({this.openType, this.todo});
}

class LocationDetailArgument {
  final String locationString;

  LocationDetailArgument(this.locationString);
}
