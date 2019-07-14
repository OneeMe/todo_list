import 'package:flutter/material.dart';

class UnknownUrlPage extends StatelessWidget {
  final String name;
  
  UnknownUrlPage(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('请求的页面 ${this.name} 不存在'),
      ),
    );
  }
}