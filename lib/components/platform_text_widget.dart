import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlatformViewTextWidget extends StatelessWidget {
  final String text;
  final String _viewType = 'platform_text_view';

  const PlatformViewTextWidget({Key key, this.text}) : super(key: key);

  void _onPlatformViewCreated(int id) {
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    Widget platformView;
    if (defaultTargetPlatform == TargetPlatform.android) {
      platformView = AndroidView(
        onPlatformViewCreated: _onPlatformViewCreated,
        viewType: _viewType,
        creationParams: text,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      platformView = UiKitView(
        onPlatformViewCreated: _onPlatformViewCreated,
        viewType: _viewType,
        creationParams: text,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
          ),
        ].toSet(),
      );
    } else {
      platformView = Text('不支持的平台');
    }
    return platformView;
  }
}
