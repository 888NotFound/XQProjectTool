//
//  CATextLayer+Common.h
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface CATextLayer (Common)

#if TARGET_OS_IPHONE
/**
 生成text 文本 注意 这种方式不适成大量文本
 
 @param str 字
 @param strColor 字颜色
 @param font 字体
 */
+ (CATextLayer *)textLayerWithStr:(NSString *)str strColor:(UIColor *)strColor font:(UIFont *)font frame:(CGRect)frame;
#else
+ (CATextLayer *)textLayerWithStr:(NSString *)str strColor:(NSColor *)strColor font:(NSFont *)font frame:(CGRect)frame contentsScale:(CGFloat)contentsScale;
#endif

@end
