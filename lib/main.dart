import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/page_route/fade_page_route.dart';
import 'package:todo_list/pages/edit_todo.dart';
import 'package:todo_list/pages/login.dart';
import 'package:todo_list/pages/register.dart';
import 'package:todo_list/pages/route_url.dart';
import 'package:todo_list/pages/todo_entry.dart';
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
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: Locale('zh'),
      initialRoute: LOGIN_PAGE_URL,
      routes: {
        TODO_ENTRY_PAGE_URL: (_) => TodoEntryPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == REGISTER_PAGE_URL) {
          return FadePageRoute((_) => RegisterPage());
        }
        if (settings.name == LOGIN_PAGE_URL) {
          return FadePageRoute((_) => LoginPage());
        }
        if (settings.name == EDIT_TODO_PAGE_URL) {
          return CupertinoPageRoute<Todo>(builder: (_) => EditTodoPage(argument: settings.arguments), fullscreenDialog: true);
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => UnknownUrlPage(settings.name));
      },
    );
  }
}
