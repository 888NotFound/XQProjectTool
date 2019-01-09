//
//  XQCustomAlertView.h
//  Appollo4
//
//  Created by WXQ on 2018/5/21.
//  Copyright © 2018年 SyKing. All rights reserved.
//

/**
 没有多输出框...后面再考虑这个吧
 
 这个是直接添加在window层上面的, 如果想调用系统弹框, 可以用XQSystemAlert这个类
 */

#import <UIKit/UIKit.h>

typedef void(^XQCustomAlertViewCallback)(NSInteger index);
typedef void(^XQCustomSheetAlertViewCallback)(NSInteger index);
typedef void(^XQCustomAlertViewTFCallback)(UITextField *tf, NSInteger index);

@interface XQCustomAlertView : UIView

@property (strong, nonatomic) UIButton *backView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *alertLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITextField *centerTF;

/**
 中间弹框

 @param titleArr 最多两个, 至少没有
 @param callback index 是点击第几个, 从左开始算起, -1是点击隐藏背景
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message titleArr:(NSArray <NSString *> *)titleArr callback:(XQCustomAlertViewCallback)callback;

/**
 中间弹框, 有输入框
 
 @param tfCallback 返回tf出去, 给外面设置需要的属性
 */
+ (void)showTFWithTitle:(NSString *)title message:(NSString *)message titleArr:(NSArray <NSString *> *)titleArr tfCallback:(void(^)(UITextField *tf))tfCallback callback:(XQCustomAlertViewTFCallback)callback;

/**
 底部弹框
 如果不要标题和副标题, 填 nil or @"", 但是取消按钮, 不要的话, 必须要填 nil
 
 @param cancalCallback -1点击背景
 */
+ (void)sheetWithTitle:(NSString *)title message:(NSString *)message dataArr:(NSArray <NSString *> *)dataArr cancelText:(NSString *)cancelText callback:(XQCustomSheetAlertViewCallback)callback cancelCallback:(XQCustomSheetAlertViewCallback)cancalCallback;

+ (void)hide;

/**
 设置当前点击背景
 tapBackHide YES点击背景隐藏
 */
+ (void)setCurrenTapBackHide:(BOOL)tapBackHide;

/**
 设置全局点击背景
 tapBackHide YES点击背景隐藏
 */
+ (void)setTapBackHide:(BOOL)tapBackHide;


/**
 设置多个按钮颜色
 */
+ (void)setItemColorWithColor:(UIColor *)color rows:(NSArray <NSNumber *> *)rows;
/**
 设置某个按钮为某个颜色
 */
+ (void)setItemColorWithColor:(UIColor *)color row:(NSInteger)row;

/**
 设置取消按钮为某个颜色
 */
+ (void)setCancelItemColorWithColor:(UIColor *)color;

@end















