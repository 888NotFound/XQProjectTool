//
//  UIDevice+TFDevice.m
//  PLTest
//
//  Created by mac on 2017/12/9.
//  Copyright © 2017年 腾飞. All rights reserved.
//

#import "UIDevice+TFDevice.h"

@implementation UIDevice (TFDevice)

+ (void)xq_changeOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}


static BOOL _xq_orientation_isAllowAll = NO;
+ (BOOL)xq_isAllowAll {
    return _xq_orientation_isAllowAll;
}

+ (void)xq_setAllow:(BOOL)isAllowAll {
    _xq_orientation_isAllowAll = isAllowAll;
}

/* appdelegate实现这个
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持全屏
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}
 */

@end
