//
//  XQGetAppInfo.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/30.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//  查看苹果商店里面的app信息

#import <Foundation/Foundation.h>

typedef void(^XQGetAppInfoSucceedBlock)(id responseObject);
typedef void(^XQGetAppInfoFailureBlock)(NSError *error);

@interface XQGetAppInfo : NSObject

/**
 从app store获取应用信息

 @param appID app的应用商店的id
 */
+ (void)getAppInfoWithAPPID:(NSString *)appID success:(XQGetAppInfoSucceedBlock)success failure:(XQGetAppInfoFailureBlock)failure;

/**
 打开应用商店某个app

 @param appID app的应用商店的id
 */
+ (BOOL)openAPPStoreWithAppID:(NSString *)appID completionHandler:(void (^)(BOOL success))completion;

/**
 打开某个url
 */
+ (BOOL)openURLWithURLStr:(NSString *)urlStr completionHandler:(void (^)(BOOL success))completion;

#ifdef DEBUG
/**
 获取fir应用信息

 @param token fir token
 @param bID 应用bundleid或者基本信息里面的应用id
 */
+ (void)getFirInfoWithToken:(NSString *)token bID:(NSString *)bID success:(XQGetAppInfoSucceedBlock)success failure:(XQGetAppInfoFailureBlock)failure;
#endif

@end
















