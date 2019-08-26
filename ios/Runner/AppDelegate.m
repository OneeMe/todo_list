#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "PlatformViewFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                            methodChannelWithName:@"todo_list.example.io/location"
                                            binaryMessenger:controller];
    
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([call.method isEqualToString:@"getCurrentLocation"]) {
            result(@{
                 @"latitude": @"39.92",
                 @"longitude": @"116.46",
                 @"description": @"北京",
            });
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    PlatformViewFactory *factory = [[PlatformViewFactory alloc] init];
    [[self registrarForPlugin:@"com.funny.flutter.platform.view"] registerViewFactory:factory withId:@"platform_text_view"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
