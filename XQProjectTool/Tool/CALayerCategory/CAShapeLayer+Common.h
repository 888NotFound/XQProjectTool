//
//  CAShapeLayer+Common.h
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (Common)

/**
 四边矩形
 
 @param color 填充颜色
 @param strokeColor 线颜色
 @param lineWidth 线宽
 */
+ (CAShapeLayer *)rectangleLayerWithRect:(CGRect)rect color:(UIColor *)color strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

/**
 生成小圆点
 
 @param radius 半径
 @param center 位置
 @param color 颜色
 */
+ (CAShapeLayer *)dotLayerWithRadius:(CGFloat)radius center:(CGPoint)center color:(UIColor *)color;

@end
