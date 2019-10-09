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

@end
