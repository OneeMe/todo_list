
import 'package:flutter/cupertino.dart';

class FadePageRoute extends PageRouteBuilder {
  final WidgetBuilder widgetBuilder;
  FadePageRoute(this.widgetBuilder) : super(
    pageBuilder: (context, _, __) => widgetBuilder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}