//
//  XQAlertSystem.h
//  MacApp
//
//  Created by WXQ on 2018/1/15.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void(^XQAlertSystemCallback)(NSInteger index);

@interface XQAlertSystem : NSObject

/**
 显示弹框
 
 @param callback index 从1000开始
 */
+ (NSAlert *)alertSheetWithTitle:(NSString *)title message:(NSString *)message contentArr:(NSArray <NSString *> *)contentArr callback:(XQAlertSystemCallback)callback;

/**
 显示错误弹框
 */
+ (NSAlert *)alertErrorWithWithWindow:(NSWindow *)window domain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict callback:(XQAlertSystemCallback)callback;

/**
 显示错误弹框
 */
+ (NSAlert *)alertErrorWithWithWindow:(NSWindow *)window error:(NSError *)error callback:(XQAlertSystemCallback)callback;

@end



