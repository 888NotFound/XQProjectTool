//
//  UIView+XQDottedLine.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/26.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XQDottedLine)

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

@end
