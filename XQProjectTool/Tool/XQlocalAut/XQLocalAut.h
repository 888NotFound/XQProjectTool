//
//  XQLocalAut.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/19.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//  指纹验证 和 密码验证

#import <Foundation/Foundation.h>

@interface XQLocalAut : NSObject

/**
 是否支持

 @return nil为可以指纹识别
 */
+ (NSError *)isSupport;

/**
 指纹/密码 验证

 @param callback 成功返回
 @param failureCallback 失败返回
 
 @note 默认如果指纹验证失败, 则调用开锁密码验证, 并且密码验证通过, 也等于通过
 */
+ (void)autBiometricsWithCallback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback;

/**
 指纹

 @param isMustFingerprint NO密码验证通过, 也等于指纹通过.  YES必须指纹通过
 @param callback 成功返回
 @param failureCallback 失败返回
 */
+ (void)autBiometricsWithIsMustFingerprint:(BOOL)isMustFingerprint callback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback;


/**
 获取本地存储是否开启验证
 */
+ (BOOL)getIsOpenLocalAut;

/**
 保存是否开启验证
 */
+ (void)saveIsOpenLocalAut:(BOOL)isOpen;

@end
