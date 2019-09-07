import 'package:flutter/widgets.dart';

class EmptyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return LimitedBox(maxWidth: 0.0,maxHeight: 0.0);
  }
}
