//
//  XQDevice.m
//  XQAddProperty
//
//  Created by ladystyle100 on 2017/9/25.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "XQDevice.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

/*
1.手机系统版本：9.1
NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];

2.手机系统：iPhone OS
NSString * iponeM = [[UIDevice currentDevice] systemName];

3.电池电量
CGFloat batteryLevel=[[UIDevicecurrentDevice]batteryLevel];
 */

// 避免重复计算
static NSString *iPhoneType_ = @"";
static CGFloat statusHeight_ = -1;

@implementation XQDevice

+ (CGFloat)getNavigationHeight {
    CGFloat nHeight = 44;
    return nHeight + [self getStatusHeight];
}

+ (CGFloat)getStatusHeight {
    if (statusHeight_ != -1) {
        return statusHeight_;
    }
    
    statusHeight_ = 20;
    
    if (@available(iOS 11.0, *)) {
        //[UIApplication sharedApplication].statusBarOrientation
        //[UIDevice currentDevice].orientation
        
        NSString *iPhoneType = [self getIPhoneType];
        
        // 真机
        if ([iPhoneType isEqualToString:@"iPhone X"]) {
            statusHeight_ = 44;
            
            // 模拟机
        }else if ([iPhoneType isEqualToString:@"iPhone Simulator"]) {
            CGRect rect = [UIScreen mainScreen].bounds;
            if (rect.size.height == 812 && rect.size.width == 375) {
                statusHeight_ = 44;
            }
            
        }
        
    }
    
    return statusHeight_;
}

+ (CGFloat)getTabbarHeight {
    if ([iPhoneType_ isEqualToString:@"iPhone X"]) {
        return 83;
    }
    return 49;
}

+ (CGFloat)getSubNavHeight {
    return [UIScreen mainScreen].bounds.size.height - [self getNavigationHeight];
}

+ (CGFloat)getSubNavAndTabHeight {
    return [self getSubNavHeight] - [self getTabbarHeight];
}

#pragma mark -- 获取机型

+ (NSString *)getIPhoneType {
    if ([iPhoneType_ isEqualToString:@""] || !iPhoneType_) {
        iPhoneType_ = [self iPhoneType];
    }
    return iPhoneType_;
}

+ (NSString *)iPhoneType {
    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])return@"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"] || [platform isEqualToString:@"iPhone9,3"])return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"] || [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"] || [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    
    if([platform isEqualToString:@"iPod1,1"])return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])return@"iPhone Simulator";
    
    
    return platform;
}

@end
