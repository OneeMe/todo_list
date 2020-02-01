import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/utils/network.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File image;
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void _register() async {
    if (await checkConnectivityResult(context) == false) {
      return;
    }
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    if (email.isEmpty || !email.contains('@')) {
      _showErrorDialog('请输入正确的邮箱');
      return;
    }
    if (password.length < 6) {
      _showErrorDialog('请输入正确的密码');
      return;
    }
    if (confirmPassword.length < 6 || confirmPassword != password) {
      _showErrorDialog('请输入正确的确认密码');
      return;
    }
    Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL, arguments: TodoEntryPageArgument(email: email));
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      builder: (_) => AlertDialog(
        title: Text('输入错误'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('确认'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      context: context,
    );
  }

  void _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48,
      backgroundImage: image == null
          ? AssetImage('assets/images/default_avatar.png')
          : FileImage(image),
    );
    final addIcon = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        color: Color.fromARGB(255, 80, 210, 194),
      ),
      child: Icon(
        Icons.add,
        size: 34,
        color: Colors.white,
      ),
    );
    final userAvatar = GestureDetector(
      onTap: () {
        _getImage();
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          avatar,
          Positioned(
            right: 20,
            top: 5,
            child: addIcon,
          ),
        ],
      ),
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: FractionallySizedBox(
                      child: userAvatar,
                      widthFactor: 0.4,
                      heightFactor: 0.4,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: '请输入邮箱',
                                labelText: '邮箱',
                              ),
                              focusNode: emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {
                                emailFocusNode.unfocus();
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              },
                            ),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: '请输入六位以上的密码',
                                labelText: '密码',
                              ),
                              focusNode: passwordFocusNode,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {
                                passwordFocusNode.unfocus();
                                FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                              },
                            ),
                            TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: '请再次输入密码',
                                labelText: '确认密码',
                              ),
                              focusNode: confirmPasswordFocusNode,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _register(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 12,
                          bottom: 12,
                        ),
                        child: FlatButton(
                          onPressed: _register,
                          color: Color.fromRGBO(69, 202, 181, 1),
                          disabledColor: Color.fromRGBO(69, 202, 160, 0.5),
                          child: Text(
                            '注册',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 12,
                          bottom: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('已有账号？'),
                            InkWell(
                              child: Text('直接登录'),
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(LOGIN_PAGE_URL);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
