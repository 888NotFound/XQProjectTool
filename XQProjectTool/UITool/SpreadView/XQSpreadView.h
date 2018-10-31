//
//  MyView.h
//  test
//
//  Created by 英赛智能 on 16/3/18.
//  Copyright © 2016年 Blue Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQSpreadView : UIView

@property (strong, nonatomic) UIImage *centerImage;

@property (nonatomic, strong) CALayer *totalRadarLayer;
@property (nonatomic, strong) CALayer *centerLayer;

/** 是否在动画中, YES在 */
@property (nonatomic, assign) BOOL isInAnimation;

- (instancetype)initWithFrame:(CGRect)frame centerImage:(UIImage *)centerImage;

/**
 开始动画

 @param color 圆圈颜色
 */
- (void)startAnimationWithColor:(UIColor *)color;

/**
 停止动画
 */
- (void)stopAnimation;

@end
