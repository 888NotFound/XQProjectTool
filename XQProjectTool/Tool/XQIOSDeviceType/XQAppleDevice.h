//
//  XQAppleDevice.h
//  AFNetworking
//
//  Created by WXQ on 2019/1/8.
//

#import <Foundation/Foundation.h>

#import "XQAppleDeviceModel.h"

#define XQ_IPhoneType [XQAppleDevice getIPhoneType]

NS_ASSUME_NONNULL_BEGIN

@interface XQAppleDevice : NSObject

/**
 获取当前机型
 */
+ (XQAppleDeviceModel *)getIOSDevType;

/**
 获取当前机型, 这个是直接获取具体字符串, 可以判断更加细致的类型
 */
+ (NSString *)getIPhoneType;



@end

NS_ASSUME_NONNULL_END
