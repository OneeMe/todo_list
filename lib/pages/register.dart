import 'package:flutter/material.dart';

class RegisterPageArgument {
  final String className;
  final String url;

  RegisterPageArgument(this.className, this.url);
}
class RegisterPage extends StatelessWidget {
  final RegisterPageArgument argument;

  RegisterPage(this.argument);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Text('注册页面，从 ${argument.className} - ${argument.url} 跳转而来)'),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      
    );
  }
}