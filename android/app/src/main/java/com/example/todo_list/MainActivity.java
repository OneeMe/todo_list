package com.example.todo_list;

import android.os.Bundle;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    // 此处的名字要和 dart 侧的一致
    private static final String CHANNEL = "todo_list.example.io/location";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PlatformTextViewFactory factory = new PlatformTextViewFactory();
        registrarFor("com.funny.flutter.platform.view").platformViewRegistry().registerViewFactory("platform_text_view", factory);
        GeneratedPluginRegistrant.registerWith(this);
        // 新建一个 MethodChannel 对象
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((MethodCall call, MethodChannel.Result result) -> {
                // 当收到名为 getCurrentLocation 的方法调用时，返回getCurrentLocation()函数的结果
                if (call.method.equals("getCurrentLocation")) {
                    result.success(getCurrentPosition());
                } else {
                    result.notImplemented();
                }
            }
        );
    }

    public HashMap getCurrentPosition() {
        // 返回当前位置
        return new HashMap<String, String>() {{
            put("latitude", "39.92");
            put("longitude", "116.46");
            put("description", "北京");
        }};
    }
}
