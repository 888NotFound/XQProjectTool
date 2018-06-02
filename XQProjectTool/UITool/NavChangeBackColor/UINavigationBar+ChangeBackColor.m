//
//  UINavigationBar+ChangeBackColor.m
//  NavigationBar
//
//  Created by SyKingW on 2017/10/14.
//  Copyright © 2017年 SyKingW. All rights reserved.
//

#import "UINavigationBar+ChangeBackColor.h"
#import <objc/runtime.h>

static NSString *overlayKey = @"NBBackColor";

@implementation UINavigationBar (ChangeBackColor)

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xq_setBackgroundColor:(UIColor *)backgroundColor
{
    
    if (!self.overlay) {
        // 想要完全透明, 必须设置这个, 还有 translucent属性为YES
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        CGFloat statusBarHeight = 20;
        if ([UIScreen mainScreen].bounds.size.height == 812) {
            statusBarHeight = 44;
        }
        
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + statusBarHeight)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.overlay.userInteractionEnabled = NO;
        
        for (UIView *view in self.subviews) {
            NSString *classStr = NSStringFromClass([view class]);
            if ([classStr containsString:@"Background"]) {
                [view addSubview:self.overlay];
                break;
            }
        }
    }
    
    if (backgroundColor == nil) {
        NSLog(@"颜色为空");
        backgroundColor = [UIColor clearColor];
    }
    
    self.overlay.backgroundColor = backgroundColor;
}

@end









