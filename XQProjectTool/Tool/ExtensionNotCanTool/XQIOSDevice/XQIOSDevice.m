//
//  XQIOSDevice.m
//  XQAddProperty
//
//  Created by ladystyle100 on 2017/9/25.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#if !XQExtensionFramework

#import "XQIOSDevice.h"

//#import "XQIPAddress.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

/*
 手机系统版本：9.1
 NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
 
 手机系统：iPhone OS
 NSString * iponeM = [[UIDevice currentDevice] systemName];
 
 电池电量
 CGFloat batteryLevel=[[UIDevicecurrentDevice] batteryLevel];
 
 状态栏
 [XQApplication sharedApplication].statusBarFrame
 */

// 避免重复计算

static CGFloat statusHeight_ = -1;

@implementation XQIOSDevice

+ (CGFloat)getNavigationHeight {
    CGFloat nHeight = 44;
    return nHeight + [self getStatusHeight];
}

+ (CGFloat)getStatusHeight {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_IPHONE
            //44是正常高度, 64是开启热点, QQ语音, 定位等等, 会增加20
#if !XQExtensionFramework
        if ([XQApplication sharedApplication].statusBarFrame.size.height == 44 ||
            [XQApplication sharedApplication].statusBarFrame.size.height == 64) {
            statusHeight_ = 44;
        }else {
            statusHeight_ = 20;
        }
#else
        statusHeight_ = 20;
#endif
        
#endif
    });
    
    return statusHeight_;
    
    if (statusHeight_ != -1) {
        return statusHeight_;
    }
    
    statusHeight_ = 20;
    
    if (@available(iOS 11.0, *)) {
        //[XQApplication sharedApplication].statusBarOrientation
        //[UIDevice currentDevice].orientation
#if !XQExtensionFramework
        NSString *iPhoneType = [XQIOSDeviceType getIPhoneType];
#else
        NSString *iPhoneType = @"iPhone 6S";
#endif
        // 真机
        if ([iPhoneType isEqualToString:@"iPhone X"]) {
            statusHeight_ = 44;
            
            // 模拟机
        }else if ([iPhoneType isEqualToString:@"iPhone Simulator"]) {
#if TARGET_OS_IPHONE
            CGRect rect = [UIScreen mainScreen].bounds;
            if (rect.size.height == 812 && rect.size.width == 375) {
                statusHeight_ = 44;
            }
#endif
            
        }
        
    }
    
    return statusHeight_;
}

+ (CGFloat)getTabbarHeight {
    if ([self getStatusHeight] == 44) {
        return 83;
    }
    return 49;
    
#if !XQExtensionFramework
    if ([[XQIOSDeviceType getIPhoneType] isEqualToString:@"iPhone X"]) {
        return 83;
    }
#endif
    
    return 49;
}

+ (CGFloat)getSubNavHeight {
    CGFloat height = 0;
#if TARGET_OS_IPHONE
    height = [UIScreen mainScreen].bounds.size.height - [self getNavigationHeight];
#endif
    return height;
}

+ (CGFloat)getSubNavAndTabHeight {
    return [self getSubNavHeight] - [self getTabbarHeight];
}

/**
 是否默认机型...就是iPhoneX为NO, iPhone7这种为YES
 */
+ (BOOL)isNormalModel {
    if ([self getStatusHeight] != 20) {
        return NO;
    }
    return YES;
}




@end



#endif




