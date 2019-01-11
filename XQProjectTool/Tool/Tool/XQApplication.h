//
//  XQApplication.h
//  LMIOTMQTTAPI
//
//  Created by WXQ on 2019/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQApplication : NSObject

#if TARGET_OS_IPHONE
+ (UIApplication *)sharedApplication;
#endif

@end

NS_ASSUME_NONNULL_END
