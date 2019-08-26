package com.example.todo_list;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import io.flutter.plugin.platform.PlatformView;

public class PlatformTextView implements PlatformView {
    private final int id;
    private TextView textView;

    PlatformTextView(Context context, int id, Object args) {
        this.id = id;
        this.textView = new TextView(context);
        this.textView.setText(args.toString());
    }

    @Override
    public View getView() {
        return this.textView;
    }

    @Override
    public void dispose() {
        this.textView = null;
    }
}
