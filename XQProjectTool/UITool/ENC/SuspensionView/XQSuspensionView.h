//
//  XQSuspensionView.h
//  XQSuspensionView
//
//  Created by WXQ on 2018/5/24.
//  Copyright © 2018年 SyKing. All rights reserved.
//

/**
 手势覆盖问题
 
 子view拥有的手势
 UISwipeGestureRecognizer: 无效
 UILongPressGestureRecognizer: 有效
 UITapGestureRecognizer: 有效
 UIPanGestureRecognizer: 覆盖父view的手势pan
 UIPinchGestureRecognizer: 有效
 UIRotationGestureRecognizer: 有效
 */

#import <UIKit/UIKit.h>
#import "XQSuspensionViewTool.h"

typedef NS_ENUM(NSInteger, XQSuspensionViewType) {
    XQSuspensionViewTypeNormal = 0,// 全屏
    XQSuspensionViewTypeRectangle, // 矩形
    XQSuspensionViewTypeRound, // 小圆形
    XQSuspensionViewTypeHide, // 隐形, 但并不销毁view
};

@interface XQSuspensionView : UIView

/**
 显示

 @param normalView 全屏view, 以下如同
 @param type 显示的样式
 */
+ (void)showWithNormalView:(UIView *)normalView
             rectangleView:(UIView *)rectangleView
        smallRectangleView:(UIView *)smallRectangleView
                 roundView:(UIView *)roundView
                      type:(XQSuspensionViewType)type;

/**
 隐藏view
 */
+ (void)hide;

/**
 获取当前view的类型
 */
+ (XQSuspensionViewType)getCurrentType;

/**
 改变view的类型
 */
+ (void)setCurrentType:(XQSuspensionViewType)type;

/**
 变回上一个viewType
 */
+ (void)changeBeforeType;

/**
 设置view的背景颜色
 */
+ (void)setViewBackColor:(UIColor *)backColor;

/**
 获取当前的view
 */
+ (XQSuspensionView *)getCurrentView;

/**
 设为最顶层的view, 就是每次, 如果要在window上加view的话...那么就得设置window最顶层
 */
+ (void)setWindowsTop;

/**
 添加手势
 */
+ (void)addPanGesture;

/**
 移除手势
 */
+ (void)removeGesture;

@end























