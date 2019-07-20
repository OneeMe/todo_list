import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list/pages/route_url.dart';

class RegisterPageArgument {
  final String className;
  final String url;

  RegisterPageArgument(this.className, this.url);
}

class RegisterPage extends StatefulWidget {
  final RegisterPageArgument argument;

  RegisterPage(this.argument);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool canRegister;
  File image;
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    canRegister = true;
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  void _register() {}

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
                              decoration: InputDecoration(
                                hintText: '请输入邮箱',
                                labelText: '邮箱',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {},
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: '请输入六位以上的密码',
                                labelText: '密码',
                              ),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: '请再次输入密码',
                                labelText: '确认密码',
                              ),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, top: 12, bottom: 12),
                        child: FlatButton(
                          onPressed: canRegister ? _register : null,
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
                            left: 24, right: 24, top: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('已有账号？'),
                            InkWell(
                              child: Text('直接登录'),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(LOGIN_PAGE_URL);
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
