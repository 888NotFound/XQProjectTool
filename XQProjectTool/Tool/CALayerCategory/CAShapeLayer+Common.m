//
//  CAShapeLayer+Common.m
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "CAShapeLayer+Common.h"

@implementation CAShapeLayer (Common)


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


@end
















