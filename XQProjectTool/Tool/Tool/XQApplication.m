//
//  XQApplication.m
//  LMIOTMQTTAPI
//
//  Created by WXQ on 2019/1/9.
//

#import "XQApplication.h"

@implementation XQApplication

#if TARGET_OS_IPHONE
+ (UIApplication *)sharedApplication {
#if !XQExtensionFramework
    return [UIApplication sharedApplication];
#else
    return nil;
#endif
}
#endif

@end
