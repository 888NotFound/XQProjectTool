//
//  UIView+XQLine.h
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XQLine)

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView
                          lineLength:(int)lineLength
                         lineSpacing:(int)lineSpacing
                           lineColor:(UIColor *)lineColor
                       lineDirection:(BOOL)isHorizonal;

/**
 视图边界线, 这里是用layer的方式
 需要注意的是, 如果传进来的view, frame是0, 那么画图也是0

 @param view 需要添加layer的视图
 @param top YES画, NO不画
 @param color 线颜色
 */
+ (void)setBorderWithView:(UIView *)view
                      top:(BOOL)top
                     left:(BOOL)left
                   bottom:(BOOL)bottom
                    right:(BOOL)right
              borderColor:(UIColor *)color
              borderWidth:(CGFloat)width;

@end
















