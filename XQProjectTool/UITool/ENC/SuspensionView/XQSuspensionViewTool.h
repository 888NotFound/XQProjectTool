//
//  XQSuspensionViewTool.h
//  XQSuspensionView
//
//  Created by WXQ on 2018/5/24.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XQSuspensionViewTool : NSObject

/**
 获取RectangleRect mode的大小
 */
+ (CGRect)getRectangleRect;

/**
 设置RectangleRect mode的大小
 */
+ (void)setRectangleRect:(CGRect)rect;

/**
 获取round mode的大小
 */
+ (CGRect)getRoundRect;
/**
 设置round mode的大小
 */
+ (void)setRoundRect:(CGRect)rect;

@end
