//
//  CAShapeLayer+Common.m
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "CAShapeLayer+Common.h"

@implementation CAShapeLayer (Common)


#if TARGET_OS_IPHONE
/**
 四边矩形
 
 @param color 填充颜色
 @param strokeColor 线颜色
 @param lineWidth 线宽
 */
+ (CAShapeLayer *)rectangleLayerWithRect:(CGRect)rect color:(UIColor *)color strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color.CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.lineWidth = lineWidth;
    layer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    return layer;
}
#else
+ (CAShapeLayer *)rectangleLayerWithRect:(CGRect)rect color:(NSColor *)color strokeColor:(NSColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    return [self baseRectangleLayerWithRect:rect color:color.CGColor strokeColor:strokeColor.CGColor lineWidth:lineWidth];
}
#endif
+ (CAShapeLayer *)baseRectangleLayerWithRect:(CGRect)rect color:(CGColorRef)color strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color;
    layer.strokeColor = strokeColor;
    layer.lineWidth = lineWidth;
#if TARGET_OS_IPHONE
    layer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
#else
    layer.path = (__bridge CGPathRef _Nullable)([NSBezierPath bezierPathWithRect:rect]);
#endif
    return layer;
}


#if TARGET_OS_IPHONE
/**
 生成小圆点
 
 @param radius 半径
 @param center 位置
 @param color 颜色
 */
+ (CAShapeLayer *)dotLayerWithRadius:(CGFloat)radius center:(CGPoint)center color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color.CGColor;
    layer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:1 clockwise:YES].CGPath;
    return layer;
}
#endif

/**
 生成小圆点

 @param radius 半径
 @param center 位置
 @param color 颜色
 */
+ (CAShapeLayer *)baseDotLayerWithRadius:(CGFloat)radius center:(CGPoint)center color:(CGColorRef)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color;
    
#if TARGET_OS_IPHONE
    layer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:1 clockwise:YES].CGPath;
#else
//    layer.path = [NSBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:1 clockwise:YES];
#endif
    
    return layer;
}


@end
















