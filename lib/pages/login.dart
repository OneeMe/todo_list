import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/components/image_hero.dart';
import 'package:todo_list/model/login_status.dart';
import 'package:todo_list/model/network_client.dart';
import 'dart:convert';

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
    LoginStatus.instance().isLoginBefore().then((bool isLoginBefore) async {
      if (isLoginBefore) {
        String email = await LoginStatus.instance().loginEmail();
        Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL, arguments: TodoEntryPageArgument(email: email));
      }
    });
    canLogin = false;
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    Tween<double> tween = Tween<double>(begin: 1.0, end: 0.6);
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
  ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('请求失败'),
        content: Text('设备尚未连入网络'),
        actions: <Widget>[
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
    return;
  }
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty || password.isNotEmpty) {
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
        },
      );
      String result = await NetworkClient.instance().login(email, password);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('服务器返回信息'),
          content: Text(
              result.isEmpty ? '登录成功' : '登录失败，服务器信息为：$result'),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
    await LoginStatus.instance().saveLoginStatus(email);
    Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL, arguments: TodoEntryPageArgument(email: email));
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
      widthFactor: 0.4 * animation.value,
      heightFactor: 0.4 * animation.value,
    );
  }
}
