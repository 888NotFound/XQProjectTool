//
//  XQIOSDevice.h
//  XQAddProperty
//
//  Created by ladystyle100 on 2017/9/25.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#if !XQExtensionFramework

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#if !XQExtensionFramework
#import "XQIOSDeviceType.h"
#endif

#define XQ_NHeight [XQIOSDevice getNavigationHeight]
#define XQ_StatusHeight [XQIOSDevice getStatusHeight]
#define XQ_TabBarHeight [XQIOSDevice getTabbarHeight]

@interface XQIOSDevice : NSObject

/**
 是否默认机型...就是iPhoneX为NO, iPhone7这种为YES
 */
+ (BOOL)isNormalModel;

/**
 获取nv bar高度
 */
+ (CGFloat)getNavigationHeight;

/**
 获取status bar高度
 */
+ (CGFloat)getStatusHeight;

/**
 获取tab bar高度
 */
+ (CGFloat)getTabbarHeight;

/**
 获取除去nv bar,tab bar高度
 */
+ (CGFloat)getSubNavAndTabHeight;

/**
 获取除去nv bar高度
 */
+ (CGFloat)getSubNavHeight;




@end




#endif



