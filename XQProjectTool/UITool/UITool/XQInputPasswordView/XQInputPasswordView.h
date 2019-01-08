//
//  XQInputPasswordView.h
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQInputPasswordView;

@protocol XQInputPasswordViewDelegate <NSObject>

/**
 插入文字
 */
- (void)inputPasswordViewDidInsertText:(XQInputPasswordView *)inputPasswordView;

/**
 插入文字, 超出界限
 */
- (void)inputPasswordViewDidInsertTextOutBounds:(XQInputPasswordView *)inputPasswordView outBoundsText:(NSString *)outBoundsText;

/**
 删除文字
 */
- (void)inputPasswordViewDidDelText:(XQInputPasswordView *)inputPasswordView;

@end

@interface XQInputPasswordView : UIView

@property (nonatomic, weak) id <XQInputPasswordViewDelegate> delegate;

/** 当前文字 */
@property (nonatomic, copy) NSString *passwordStr;
/** 密码长度, 默认6 */
@property (nonatomic, assign) NSUInteger pwLength;
/** YES安全输入, 默认YES */
@property (nonatomic, assign) BOOL isSecure;
/** 键盘样式, 默认UIKeyboardTypeNumberPad, ....其实现在还没支持其他键盘, 有问题, 而且在iPad上面是能输入英文什么的.. */
@property (nonatomic, assign) UIKeyboardType xq_keyboardType;

/** 方框top y  0 ~ 2, ....倍数了..1是中心点 */
@property (nonatomic, assign) NSUInteger boxTopY;
/** 方框左间隔 */
@property (nonatomic, assign) NSUInteger boxLeftSpacing;
/** 方框右间隔 */
@property (nonatomic, assign) NSUInteger boxRightSpacing;
/** 方框中间间隔 */
@property (nonatomic, assign) NSUInteger boxSpacing;
/** 方框颜色 */
@property (nonatomic, strong) UIColor *boxColor;
/** 方框线宽 */
@property (nonatomic, assign) CGFloat boxLinewidth;
/** 方框填充色 */
@property (nonatomic, strong) UIColor *boxFillColor;

/** 字和*大小 */
@property (nonatomic, assign) CGFloat fontSize;
/** 字和*颜色 */
@property (nonatomic, strong) UIColor *fontColor;


@end


















