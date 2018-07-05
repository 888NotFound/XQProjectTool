//
//  NSNotificationCenter+XQBase.h
//  Appollo4
//
//  Created by WXQ on 2018/6/14.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XQ_AddNT(ntName) [self xq_addObserver:observer selector:aSelector name:ntName]
#define XQ_PostNT(ntName, obj) [self xq_postNotificationName:ntName object:obj]
#define XQ_PostNTU(ntName, obj, aUserInfo) [self xq_postNotificationName:ntName object:obj userInfo:aUserInfo]

#define XQ_NTIMP(mName, ntName) + (void)xq_add##mName##WithObserver:(id)observer selector:(SEL)aSelector {\
XQ_AddNT(ntName);\
}\
+ (void)xq_post##mName##WithObject:(id)anObject {\
XQ_PostNT(ntName, anObject);\
}\
+ (void)xq_post##mName##WithObject:(id)anObject userInfo:(NSDictionary *)aUserInfo {\
XQ_PostNTU(ntName, anObject, aUserInfo);\
}

#define XQ_NTHeader(mName) + (void)xq_add##mName##WithObserver:(id)observer selector:(SEL)aSelector;\
+ (void)xq_post##mName##WithObject:(id)anObject;\
+ (void)xq_post##mName##WithObject:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@interface NSNotificationCenter (XQBase)

/**
 进入后台
 */
+ (void)xq_addApplicationDidEnterBackgroundNotificationWithObserver:(id)observer selector:(SEL)aSelector;

/**
 进入前台
 */
+ (void)xq_addApplicationWillEnterForegroundNotificationWithObserver:(id)observer selector:(SEL)aSelector;

/**
 键盘已经显示
 */
+ (void)xq_addKeyboardDidShowNotificationWithObserver:(id)observer selector:(SEL)aSelector;

/**
 键盘已经消失
 */
+ (void)xq_addKeyboardDidHideNotificationWithObserver:(id)observer selector:(SEL)aSelector;

/**
 添加通知
 */
+ (void)xq_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName;

/**
 发送通知
 */
+ (void)xq_postNotificationName:(NSNotificationName)aName object:(id)anObject;
+ (void)xq_postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

/**
 移除通知
 */
+ (void)xq_removeObserver:(id)obj;
+ (void)xq_removeObserver:(id)obj name:(NSNotificationName)name;

@end















