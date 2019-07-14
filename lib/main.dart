import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/pages/login.dart';
import 'package:todo_list/pages/register.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/pages/unknown_url_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR,
        indicatorColor: ACCENT_COLOR,
        accentColor: PRIMARY_COLOR,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh', 'CN'),
      ],
      initialRoute: LOGIN_PAGE_URL,
      routes: {
        LOGIN_PAGE_URL: (conetxt) => LoginPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == REGISTER_PAGE_URL) {
          return MaterialPageRoute(builder: (conetxt) => RegisterPage(settings.arguments));
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => UnknownUrlPage(settings.name));
      },
    );
  }
}
