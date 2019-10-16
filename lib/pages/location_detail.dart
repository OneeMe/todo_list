import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/components/platform_text_widget.dart';
import 'package:todo_list/pages/route_url.dart';

class LocationDetailPage extends StatelessWidget {
  final LocationDetailArgument argument;

  const LocationDetailPage({Key key, this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('地点详情'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: PlatformViewTextWidget(
            text: argument.locationString,
          ),
        ),
      ),
    );
  }
}
