import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/platform_channel/channel.dart';

/// 用于 LocationFieldWrapper 组件的日期值控制器
class LocationFieldController extends ValueNotifier<Location> {
  LocationFieldController({Location location}) : super(location);

  Location get location => value;

  set location(Location newLocation) {
    value = newLocation;
  }

  void clear() {
    value = null;
  }
}

/// 支持用户点击弹出的日期选择器组件
class LocationFieldWrapper extends StatefulWidget {
  const LocationFieldWrapper({
    Key key,
    @required this.controller,
    @required this.child,
  })  : assert(controller != null),
        super(key: key);

  /// 用于获取和设置位置的控制器
  final LocationFieldController controller;

  /// 用来展示选择的位置的组件
  final Widget child;

  @override
  _LocationFieldWrapperState createState() => _LocationFieldWrapperState();
}

class _LocationFieldWrapperState extends State<LocationFieldWrapper> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AbsorbPointer(
        child: Stack(
          children: <Widget>[
            isLoading ? Center(child: CircularProgressIndicator(),) : Container(),
            Opacity(
              child: widget.child,
              opacity: isLoading ? 0.5 : 1.0,
            )
          ],
        )
      ),
      /// 当点击 child 组件的时候会弹出日期选择对话框
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        Location location = await Channel.getCurrentLocation();
        widget.controller.location = location;
        setState(() {
          isLoading = false;
        });
      },
    );
  }
}
