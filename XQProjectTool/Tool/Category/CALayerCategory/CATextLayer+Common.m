//
//  CATextLayer+Common.m
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "CATextLayer+Common.h"

@implementation CATextLayer (Common)


/**
 生成text 文本 注意 这种方式不适成大量文本

 @param str 字
 @param strColor 字颜色
 @param font 字体
 */
+ (CATextLayer *)textLayerWithStr:(NSString *)str strColor:(UIColor *)strColor font:(UIFont *)font frame:(CGRect)frame {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.string = str;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = frame;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    textLayer.foregroundColor = strColor.CGColor;
    CGFontRelease(fontRef);
    return textLayer;
}

@end
