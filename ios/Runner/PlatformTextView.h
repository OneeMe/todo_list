//
//  PlatformTextView.h
//  Runner
//
//  Created by Forelax on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformTextView : NSObject<FlutterPlatformView>

-(instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args;

@end

NS_ASSUME_NONNULL_END
