//
//  XQ_Image_type+Color.h
//  XQ_Image_type+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if TARGET_OS_IPHONE
#define XQ_Image_type UIImage
#else
#define XQ_Image_type NSImage
#endif

#if TARGET_OS_IPHONE
#define XQ_Color_Type UIColor
#else
#define XQ_Color_Type NSColor
#endif

@interface XQ_Image_type (Color)

/** 根据颜色生成纯色图片 */
+ (XQ_Image_type *)imageWithColor:(XQ_Color_Type *)color;

/** 取图片某一像素的颜色 */
- (XQ_Color_Type *)colorAtPixel:(CGPoint)point;

/** 获得灰度图 */
- (XQ_Image_type *)convertToGrayImage;

/// 改变图片颜色
/// @param tintColor 要改变成什么颜色
- (XQ_Image_type *)xq_imageWithTintColor:(XQ_Color_Type *)tintColor;

/// 判断图片亮暗
/// @return YES 亮，NO 暗
+ (BOOL)xq_imageIsLightWithImage:(UIImage *)image;

/// 判断图片亮暗
/// @param pixel 遍历跳过的像素, 1就是没跳过，2就是跳一个，一般 2 ~ 4 就行了
/// @param average 超过哪个平均值算亮
/// @return YES 亮，NO 暗
+ (BOOL)xq_imageIsLightWithImage:(UIImage *)image pixel:(int)pixel average:(int)average;

/// 根据图片获取图片的主色调
/// 奥卡姆剃须刀 https://www.jianshu.com/p/cc86c65979e6
/// 也可用其他库 https://github.com/tangdiforx/iOSPalette， 不过就懒的搞了需求不高
+ (UIColor *)xq_getImageMainColorWithImage:(UIImage *)image;

@end
