//
//  XQApplication.m
//  LMIOTMQTTAPI
//
//  Created by WXQ on 2019/1/9.
//

#import "XQApplication.h"

@implementation XQApplication

+ (UIApplication *)sharedApplication {
#if !XQExtensionFramework
    return [UIApplication sharedApplication];
#else
    return nil;
#endif
}

@end
