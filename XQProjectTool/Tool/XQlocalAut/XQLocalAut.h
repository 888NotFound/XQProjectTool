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
 指纹验证

 @param callback 成功返回
 @param failureCallback 失败返回
 */
+ (void)autBiometricsWithCallback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback;


/**
 获取本地存储是否开启验证
 */
+ (BOOL)getIsOpenLocalAut;

/**
 保存是否开启验证
 */
+ (void)saveIsOpenLocalAut:(BOOL)isOpen;

@end
