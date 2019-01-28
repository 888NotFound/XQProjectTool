//
//  UIView+ColorProgress.h
//  XQLocalizedString
//
//  Created by WXQ on 2018/4/20.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 ) // 360 转 3.14 * 2
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI ) // 3.14 * 2 转 360
#define SQR(x)            ( (x) * (x) )



@interface UIView (ColorProgress)

/**
 画曲线渐变
 在 drawRect: 方法中调用
 
 @param lineWidth 线宽
 @param radius 半径
 @param centerPoint 中心点
 @param startAngle 开始角度, 角度0是为3点钟, 目前是顺时针画
 @param endAngle 结束角度
 @param pStartAngle 进度的开始角度
 @param pEndAngle 进度的结束角度
 @param colorArr (id)[UIColor blueColor].CGColor 这样的格式
 @param backColor 背景颜色
 @param clockwise YES逆时针, NO顺时针
 */
- (void)drawArcColorProgressWithLineWidth:(CGFloat)lineWidth
                                   radius:(CGFloat)radius
                              centerPoint:(CGPoint)centerPoint
                               startAngle:(CGFloat)startAngle
                                 endAngle:(CGFloat)endAngle
                              pStartAngle:(CGFloat)pStartAngle
                                pEndAngle:(CGFloat)pEndAngle
                                 colorArr:(NSArray *)colorArr
                                backColor:(UIColor *)backColor
                                clockwise:(BOOL)clockwise;

/**
 绘制一个圆
 
 @param color 填充颜色
 @param point 坐标
 @param radius 圆半径
 */
- (void)drawRoundWithColor:(UIColor *)color point:(CGPoint)point radius:(CGFloat)radius;

@end


    //从苹果是示例代码clockControl中拿来的函数
    //计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >= 0  ? result : result + 360.0);
}

/**
 获取某一点
 
 @param center 圆的中心
 @param angle 圆的角度
 @param radius 圆的半径
 */
static inline CGPoint xq_getCircleCoordinateWithCenter(CGPoint center, CGFloat angle, CGFloat radius) {
        //根据角度得到圆环上的坐标
    CGFloat y = round(center.y + radius * sin(ToRad(angle)));
    CGFloat x = round(center.x + radius * cos(ToRad(angle)));
    return CGPointMake(x, y);
}










