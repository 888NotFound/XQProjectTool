//
//  UINavigationBar+ChangeBackColor.m
//  NavigationBar
//
//  Created by SyKingW on 2017/10/14.
//  Copyright © 2017年 SyKingW. All rights reserved.
//

#import "UINavigationBar+ChangeBackColor.h"
#import <objc/runtime.h>
#import "XQIOSDevice.h"

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
        // iOS12之后, 在初始化里面调用是没有subview的, 需要在viewDidAppear里面调用...才会有
        if (self.subviews.count == 0) {
            return;
        }
        // 想要完全透明, 必须设置这个, 还有 translucent属性为YES
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        CGFloat statusBarHeight = 20;
        
        if ([XQIOSDevice isNormalModel] == NO) {
            statusBarHeight = 44;
        }
        
        // iOS12的Y好像也不是负的了, 直接填0就行
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









