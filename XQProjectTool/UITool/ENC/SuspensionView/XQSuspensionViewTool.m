//
//  XQSuspensionViewTool.m
//  XQSuspensionView
//
//  Created by WXQ on 2018/5/24.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQSuspensionViewTool.h"

#define XQ_Screen_Width [UIScreen mainScreen].bounds.size.width
#define XQ_Screen_Height [UIScreen mainScreen].bounds.size.height

@implementation XQSuspensionViewTool

/**
 获取free mode的大小
 */
+ (CGRect)getRectangleRect {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"xq_sv_Rectangle"];
    if (!str) {
        return CGRectMake(0, 0, XQ_Screen_Width, XQ_Screen_Width * 0.75);
    }
    return CGRectFromString(str);
}

/**
 设置round mode的大小
 */
+ (void)setRectangleRect:(CGRect)rect {
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(rect) forKey:@"xq_sv_Rectangle"];
}

/**
 获取free mode的大小
 */
+ (CGRect)getSmallRectangleRect {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"xq_sv_SmallRectangle"];
    if (!str) {
        return CGRectMake(0, 0, XQ_Screen_Width/3, 60);
    }
    return CGRectFromString(str);
}

/**
 设置free mode的大小
 */
+ (void)setSmallRectangleRect:(CGRect)rect {
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(rect) forKey:@"xq_sv_SmallRectangle"];
}

/**
 获取round mode的大小
 */
+ (CGRect)getRoundRect {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"xq_sv_roundRect"];
    if (!str) {
        CGFloat width = 80;
        return CGRectMake(0, 0, width, width);
    }
    return CGRectFromString(str);
}

/**
 设置free mode的大小
 */
+ (void)setRoundRect:(CGRect)rect {
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(rect) forKey:@"xq_sv_roundRect"];
}



@end

















