import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_list/components/image_hero.dart';
import 'dart:convert';

import 'package:todo_list/pages/register.dart';
import 'package:todo_list/pages/route_url.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool canLogin;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  Animation<double> _animation;
  AnimationController _animationController;
  bool _isInit;

  @override
  void initState() {
    super.initState();
    canLogin = false;
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    Tween<double> tween = Tween<double>(begin: 1.0, end: 0.2);
    Animation<double> parentAnimation = tween.animate(_animationController);
    _animation =
        CurvedAnimation(parent: parentAnimation, curve: Curves.elasticInOut);
    _animation.addListener(() {
      setState(() {});
    });
    _isInit = false;
    Future.delayed(Duration(seconds: 0)).then((value) {
      setState(() {
        _isInit = true;
      });
    });
    _animationController.forward().then((value) {
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
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
    Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL);
    // String email = _emailController.text;
    // String password = _passwordController.text;
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               CircularProgressIndicator(),
    //               Text('请求中...'),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    // Response response = await post('http://10.0.2.2:8989/login',
    //     body: JsonEncoder().convert({
    //       'email': email,
    //       'password': password,
    //     }),
    //     headers: {
    //       'Content-Type': 'application/json',
    //     });
    // Map<String, dynamic> body = JsonDecoder().convert(response.body);

    // Navigator.of(context).pop();
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => AlertDialog(
    //           title: Text('服务器返回信息'),
    //           content: Text(body['error'].isEmpty
    //               ? '登录成功'
    //               : '登录失败，服务器信息为：${body['error']}'),
    //           actions: <Widget>[
    //             FlatButton(
    //               child: Text('确定'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         ));
  }

  @override
  Widget build(BuildContext context) {
    String imageKey = 'assets/images/mark.png';
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
                      child: FractionallySizedTrasition(
                        animation: _animation,
                        child: _isInit
                            ? Image.asset(imageKey)
                            : ImageHero(imageKey: imageKey),
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
                          onPressed: _login,
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
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed(REGISTER_PAGE_URL),
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

class FractionallySizedTrasition extends AnimatedWidget {
  final Widget child;
  FractionallySizedTrasition({Key key, Animation<double> animation, this.child})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return FractionallySizedBox(
      child: child,
      widthFactor: animation.value,
      heightFactor: animation.value,
    );
  }
}
