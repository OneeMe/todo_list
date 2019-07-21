import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 用于 DateField 组件的日期值控制器
class DateFieldController extends ValueNotifier<DateTime> {
  DateFieldController({DateTime date}) : super(date);

  DateTime get date => value;

  set date(DateTime newDateTime) {
    value = newDateTime;
  }

  void clear() {
    value = null;
  }
}

/// 支持用户点击弹出的日期选择器组件
class DateFieldWrapper extends StatelessWidget {
  const DateFieldWrapper({
    Key key,
    @required this.controller,
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    this.selectableDayPredicate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.builder,
    @required this.child,
  })  : assert(controller != null),
        super(key: key);

  /// 用于获取和设置日期值的控制器
  final DateFieldController controller;

  /// 设置弹窗出现时默认选中的日期
  final DateTime initialDate;

  /// 设置用户可以选择的日期上界
  final DateTime firstDate;

  /// 设置用户可以选择的日期下界
  final DateTime lastDate;

  /// 设置一个函数，更加精确的设置哪些日期可以被选中，哪些不能被选中
  final SelectableDayPredicate selectableDayPredicate;

  /// 设置选择模式，是用来选择年份，还是选择月和日。默认是用来选择月和日的
  final DatePickerMode initialDatePickerMode;

  /// 给弹窗设置一个父亲组件。可以用来给对话框设置继承组件，如 Theme、MediaQuery等
  final TransitionBuilder builder;

  /// 用来展示选择的日期的组件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AbsorbPointer(
        child: child,
      ),
      /// 当点击 child 组件的时候会弹出日期选择对话框
      onTap: () async {
        DateTime date = controller.date ?? initialDate;
        /// 弹出日期选择对话框
        DateTime selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: firstDate,
          lastDate: lastDate,
          selectableDayPredicate: selectableDayPredicate,
          initialDatePickerMode: initialDatePickerMode,
          builder: builder,
        );

        /// 将用户选择的日期的日期赋值给控制器
        if (selectedDate != null) {
          controller.date = selectedDate;
        }
      },
    );
  }
}
