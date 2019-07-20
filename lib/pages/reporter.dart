import 'package:flutter/material.dart';

class ReporterPage extends StatelessWidget {
  const ReporterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(this.runtimeType.toString()),
    );
  }
}