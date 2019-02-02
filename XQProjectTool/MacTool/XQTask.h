//
//  XQTask.h
//  AFNetworking
//
//  Created by WXQ on 2019/1/14.
//

#if TARGET_OS_OSX

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQTask : NSObject

/**
 重启
 */
+ (void)restart;

/**
 多开
 */
+ (void)multipleOpen;

@end

NS_ASSUME_NONNULL_END

#endif
