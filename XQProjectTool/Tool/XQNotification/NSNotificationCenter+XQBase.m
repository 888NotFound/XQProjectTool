//
//  NSNotificationCenter+XQBase.m
//  Appollo4
//
//  Created by WXQ on 2018/6/14.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#define XQ_AddNT(ntName) [self xq_addObserver:observer selector:aSelector name:ntName]

#import "NSNotificationCenter+XQBase.h"
#import <UIKit/UIKit.h>

@implementation NSNotificationCenter (XQBase)

+ (void)xq_addApplicationDidEnterBackgroundNotificationWithObserver:(id)observer selector:(SEL)aSelector {
    XQ_AddNT(UIApplicationDidEnterBackgroundNotification);
}

+ (void)xq_addApplicationWillEnterForegroundNotificationWithObserver:(id)observer selector:(SEL)aSelector {
    XQ_AddNT(UIApplicationWillEnterForegroundNotification);
}

+ (void)xq_addKeyboardDidShowNotificationWithObserver:(id)observer selector:(SEL)aSelector {
    XQ_AddNT(UIKeyboardDidShowNotification);
}

+ (void)xq_addKeyboardDidHideNotificationWithObserver:(id)observer selector:(SEL)aSelector {
    XQ_AddNT(UIKeyboardDidHideNotification);
}

+ (void)xq_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:nil];
}

+ (void)xq_postNotificationName:(NSNotificationName)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject];
}

+ (void)xq_postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

/**
 移除通知
 */
+ (void)xq_removeObserver:(id)obj {
    [[NSNotificationCenter defaultCenter] removeObserver:obj];
}

+ (void)xq_removeObserver:(id)obj name:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:name object:nil];
}

@end
