//
//  XQDevice.h
//  XQAddProperty
//
//  Created by ladystyle100 on 2017/9/25.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define XQ_IPhoneType [XQDevice getIPhoneType]

#define XQ_NHeight [XQDevice getNavigationHeight]
#define XQ_StatusHeight [XQDevice getStatusHeight]
#define XQ_TabBarHeight [XQDevice getTabbarHeight]

@interface XQDevice : NSObject

/** 获取当前机型 */
+ (NSString *)getIPhoneType;

/** 目前只用来获取正常方向的高度, 并没适配手机旋转 */
/** 获取导航栏高度 */
+ (CGFloat)getNavigationHeight;
/** 获取状态栏高度 */
+ (CGFloat)getStatusHeight;
/** 获取标签栏高度 */
+ (CGFloat)getTabbarHeight;

/** 获取除去导航栏, 标签栏高度 */
+ (CGFloat)getSubNavAndTabHeight;
/** 获取除去导航栏高度 */
+ (CGFloat)getSubNavHeight;


@end








