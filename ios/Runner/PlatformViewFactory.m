//
//  PlatformViewFactory.m
//  Runner
//
//  Created by Forelax on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "PlatformViewFactory.h"
#import "PlatformTextView.h"

@implementation PlatformViewFactory

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    PlatformTextView *textView = [[PlatformTextView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args];
    return textView;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
