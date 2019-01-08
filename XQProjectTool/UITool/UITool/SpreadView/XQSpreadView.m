//
//  MyView.m
//  test
//
//  Created by 英赛智能 on 16/3/18.
//  Copyright © 2016年 Blue Media. All rights reserved.
//

#import "XQSpreadView.h"

@implementation XQSpreadView

- (instancetype)initWithFrame:(CGRect)frame centerImage:(UIImage *)centerImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.centerImage = centerImage;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (void)startAnimationWithColor:(UIColor *)color {
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    [self stopAnimation];
    self.isInAnimation = YES;
    self.hidden = NO;
        //扩散的圈数
    NSInteger radarLayerCount = 6;
        //动画时间
    CGFloat animationDuration = 3;
    
    if (!self.centerLayer) {
        CALayer *centerLayer = [CALayer layer];
        centerLayer.frame = CGRectMake(self.bounds.size.width/2- 30, self.bounds.size.height/2 - 30, 60, 60);
        UIImage *image = self.centerImage ? self.centerImage : [UIImage imageNamed:@"phone4"];
        centerLayer.contents = (id)image.CGImage;
        [self.layer addSublayer:centerLayer];
        self.centerLayer = centerLayer;
    }
    
    if (!self.totalRadarLayer) {
        self.totalRadarLayer = [CALayer layer];
        [self.layer insertSublayer:self.totalRadarLayer below:self.centerLayer];
    }
    
    for (int i = 0; i < radarLayerCount; i++) {
        
        CALayer * radarLayer = [CALayer layer];
        
        CGFloat diameter = self.bounds.size.width;  //扩散的大小
                                                   //        radarLayer.bounds =CGRectMake(0, 0, diameter, diameter);
        
        radarLayer.frame = CGRectMake(self.bounds.size.width/2- diameter/2, self.bounds.size.height/2 - diameter/2, diameter, diameter);
            //设置圆角变为圆形
        radarLayer.cornerRadius =diameter/2;
            //        radarLayer.position = self.center;
        
            //填充颜色的圆扩散
        radarLayer.backgroundColor = color.CGColor;//RGBColor(243, 143, 74)
                                                          //圆形扩散
        radarLayer.borderWidth = 5;
        radarLayer.borderColor = color.CGColor;
        
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
            //因为还没开始动画时不会显示出来，这里设置成显示动画开始时的状态
        animationGroup.fillMode = kCAFillModeBackwards;
            //最重要的地方，设置动画的不同的开始时间，形成扩散效果
        animationGroup.beginTime = CACurrentMediaTime() + i * animationDuration / radarLayerCount;
        animationGroup.duration =animationDuration;
        animationGroup.repeatCount =HUGE;//重复无限次
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue =@0;//开始的大小
        scaleAnimation.toValue =@1.0;//最后的大小
        scaleAnimation.duration =animationDuration;
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration =animationDuration;
        opacityAnimation.values =@[@0, @0.7,@0];
        opacityAnimation.keyTimes =@[@0, @0.5,@1];
        animationGroup.animations =@[scaleAnimation, opacityAnimation];
        
        [radarLayer addAnimation:animationGroup forKey:@"pulsing"];
        
        [self.totalRadarLayer addSublayer:radarLayer];
    }
    
}

- (void)stopAnimation {
    self.isInAnimation = NO;
    if (!self.totalRadarLayer) {
        return;
    }
    self.hidden = YES;
    
    [self.totalRadarLayer removeFromSuperlayer];
    self.totalRadarLayer = nil;
//    for (CALayer *layer in self.totalRadarLayer.sublayers) {
//        if ([layer.animationKeys containsObject:@"pulsing"]) {
//            [layer removeAllAnimations];
//            [layer removeFromSuperlayer];
//            break;
//        }
//    }
}

- (void)dealloc {
    NSLog(@"扩散图释放");
}

@end















