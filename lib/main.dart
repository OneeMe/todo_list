import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const int ThemeColor = 0xFF50D2C2;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(ThemeColor),
        indicatorColor: Colors.white,
        accentColor: Color(ThemeColor),
      ),
      home: MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: Text('这即将是一个 Todo App')),
    );
  }
}