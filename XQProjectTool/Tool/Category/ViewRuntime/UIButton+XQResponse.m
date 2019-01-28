//
//  UIButton+XQResponse.m
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//


#import "UIButton+XQResponse.h"
//#import <objc/runtime.h>
#import <objc/message.h>
#import <AudioToolbox/AudioToolbox.h>

static char * touchUpInside_ = "64";

#if TARGET_OS_IPHONE

@interface UIButton ()

@end

@implementation UIButton (XQResponse)

#else

@interface NSButton ()

@end

@implementation NSButton (XQResponse)

#endif

#if TARGET_OS_IPHONE
- (void)xq_addEvent:(UIControlEvents)event callback:(XQBtnClick)callback {
    if (!callback) {
        NSLog(@"click is nil");
        return;
    }
    const char * str =  [self getEventStr:event];
    objc_setAssociatedObject(self, str, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    /** 现在模拟写两个, 可以照着这个思路, 一个一个全部写下去 */
    SEL sel = nil;
    switch (event) {
        case UIControlEventTouchDown:{
            sel = @selector(respondsToTouchDown:);
        }
            break;
            
        case UIControlEventTouchUpInside:{
            sel = @selector(respondsToTouchUpInside:);
        }
            break;
            
        default:
            // 默认为点下内部起来
            event = UIControlEventTouchUpInside;
            sel = @selector(respondsToTouchUpInside:);
            break;
    }
    
    [self addTarget:self action:sel forControlEvents:event];
}

/** 用char做key */
- (const char *)getEventStr:(UIControlEvents)events {
    switch (events) {
        case UIControlEventTouchUpInside:
            return touchUpInside_;
            break;
            
        default:
            return touchUpInside_;
            break;
    }
}

- (void)clickWithEvents:(UIControlEvents)events {
    const char * str =  [self getEventStr:events];
    XQBtnClick click = objc_getAssociatedObject(self, str);
    if (click) {
        click(self);
    }else {
        NSLog(@"block不存在");
    }
}

#pragma mark -- respondsTo... 这边就比较苦逼了，得一直写完所有方法, 目前没想到比较好的解决方法

- (void)respondsToTouchDown:(UIButton *)sender {
    [self clickWithEvents:UIControlEventTouchDown];
}

- (void)respondsToTouchUpInside:(UIButton *)sender {
    
    AudioServicesPlaySystemSound(1520);
    [self clickWithEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

#endif

@end

















