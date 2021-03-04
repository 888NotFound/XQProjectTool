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

@implementation UIControl (XQResponse)

#if TARGET_OS_IPHONE
- (void)xq_control_addEvent:(UIControlEvents)event callback:(XQButtonClick)callback {
    if (!callback) {
        NSLog(@"click is nil");
        return;
    }
    const char * str =  [self getEventStr:event];
    objc_setAssociatedObject(self, str, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    /** 现在模拟写两个, 可以照着这个思路, 一个一个全部写下去 */
    SEL sel = nil;
    switch (event) {
        case UIControlEventValueChanged:{
            sel = @selector(respondsToValueChanged:);
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
            
        case UIControlEventValueChanged:
            return [NSString stringWithFormat:@"%lu", (unsigned long)events].UTF8String;
            break;
            
        default:
            return touchUpInside_;
            break;
    }
}

- (void)clickWithEvents:(UIControlEvents)events {
    const char * str =  [self getEventStr:events];
    XQButtonClick click = objc_getAssociatedObject(self, str);
    if (click) {
        click(self);
    }else {
        NSLog(@"block不存在");
    }
}

#pragma mark -- respondsTo... 这边就比较苦逼了，得一直写完所有方法, 目前没想到比较好的解决方法

- (void)respondsToValueChanged:(UIButton *)sender {
    [self clickWithEvents:UIControlEventValueChanged];
}

- (void)respondsToTouchUpInside:(UIButton *)sender {
//    AudioServicesPlaySystemSound(1520);
    [self clickWithEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

#endif

@end


@implementation UIButton (XQResponse)

- (void)xq_addEvent:(UIControlEvents)event callback:(XQButtonClick)callback {
    [self xq_control_addEvent:event callback:callback];
}

@end

@implementation UISlider (XQResponse)

/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSliderClick)callback {
    [self xq_control_addEvent:event callback:^(UIButton * _Nonnull sender) {
        if (callback) {
            callback((UISlider *)sender);
        }
    }];
}

@end


@implementation UISwitch (XQResponse)

/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSwitchClick)callback {
    [self xq_control_addEvent:event callback:^(UIButton * _Nonnull sender) {
        if (callback) {
            callback((UISwitch *)sender);
        }
    }];
}

@end

















