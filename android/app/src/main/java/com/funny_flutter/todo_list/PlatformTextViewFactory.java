package com.funny_flutter.todo_list;

import android.content.Context;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class PlatformTextViewFactory extends PlatformViewFactory {

    PlatformTextViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {
        return new PlatformTextView(context, i, o);
    }
}
