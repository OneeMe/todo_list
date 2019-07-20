import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:todo_list/pages/register.dart';
import 'package:todo_list/pages/route_url.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool canLogin;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    canLogin = false;
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  void _checkInputValid(String _) {
    bool isInputValid = _emailController.text.contains('@') &&
        _passwordController.text.length >= 6;
    if (isInputValid == canLogin) {
      return;
    }
    setState(() {
      canLogin = isInputValid;
    });
  }

  _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('请求中...'),
                ],
              ),
            ),
          );
        });
    Response response = await post('http://10.0.2.2:8989/login',
        body: JsonEncoder().convert({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        });
    Map<String, dynamic> body = JsonDecoder().convert(response.body);

    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('服务器返回信息'),
              content: Text(body['error'].isEmpty
                  ? '登录成功'
                  : '登录失败，服务器信息为：${body['error']}'),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          emailFocusNode.unfocus();
          passwordFocusNode.unfocus();
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
                    child: Center(
                      child: FractionallySizedBox(
                        child: Image.asset('assets/images/mark.png'),
                        widthFactor: 0.4,
                        heightFactor: 0.4,
                      ),
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
                              focusNode: emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {
                                emailFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              },
                              onChanged: _checkInputValid,
                              controller: _emailController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: '请输入六位以上的密码',
                                labelText: '密码',
                              ),
                              obscureText: true,
                              focusNode: passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              onChanged: _checkInputValid,
                              controller: _passwordController,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, top: 12, bottom: 12),
                        child: FlatButton(
                          onPressed: canLogin ? _login : null,
                          color: Color.fromRGBO(69, 202, 181, 1),
                          disabledColor: Color.fromRGBO(69, 202, 160, 0.5),
                          child: Text(
                            '登录',
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
                            Text('没有账号？'),
                            InkWell(
                              child: Text('立即注册'),
                              onTap: () => Navigator.of(context).pushReplacementNamed(REGISTER_PAGE_URL),
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
