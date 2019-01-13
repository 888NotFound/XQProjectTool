//
//  XQSystemAlert.h
//  AppolloVensi
//
//  Created by YJH on 2017/11/3.
//  Copyright © 2017年 shishuzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 这两个宏的意思是不用写是否为空, 其实这个是否为空, 一是为了让人看明白这个参数, 二是为了和Swift兼容
//NS_ASSUME_NONNULL_BEGIN
//NS_ASSUME_NONNULL_END

typedef void(^XQSystemAlertBlock)(UIAlertController  * _Nonnull alert, NSUInteger index);
typedef void(^XQSystemAlertCancelBlock)(UIAlertController * _Nonnull alert);
typedef void(^XQSystemAlertTextFieldBlock)(NSUInteger index, UITextField * _Nonnull textField);

typedef void(^XQSystemAlertActionBlock)(UIAlertController * _Nonnull alert);

@interface XQSystemAlert : NSObject

/** 弹框
 *  注意, 如果 contentArr and cancelText都为空, 则不会出现弹框, 因为这时候弹框是无法取消的
 */
+ (UIAlertController *)alertWithTitle:(NSString *_Nullable)title
                              message:(NSString *_Nullable)message
                           contentArr:(NSArray *_Nullable)contentArr
                           cancelText:(NSString *_Nullable)cancelText
                                   vc:(UIViewController *_Nullable)vc
                      contentCallback:(XQSystemAlertBlock _Nullable)contentCallback
                       cancelCallback:(XQSystemAlertCancelBlock _Nullable)cancelCallback;

/**
 有输入框的弹框
 
 @param textFieldCount 输入框个数
 @param textFieldBlock 在这里面设置输入框属性
 */
+ (UIAlertController *)alertWithTitle:(NSString *_Nullable)title
                              message:(NSString *_Nullable)message
                           contentArr:(NSArray *_Nullable)contentArr
                           cancelText:(NSString *_Nullable)cancelText
                                   vc:(UIViewController *_Nullable)vc
                       textFieldCount:(NSUInteger)textFieldCount
                       textFieldBlock:(XQSystemAlertTextFieldBlock _Nullable)textFieldBlock
                      contentCallback:(XQSystemAlertBlock _Nullable)contentCallback
                       cancelCallback:(XQSystemAlertCancelBlock _Nullable)cancelCallback;

/** 底部弹框, iPad默认就从最底部的中间弹出来 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *_Nullable)title
                                    message:(NSString *_Nullable)message
                                 contentArr:(NSArray *_Nullable)contentArr
                                 cancelText:(NSString *_Nullable)cancelText
                                         vc:(UIViewController *_Nullable)vc
                            contentCallback:(XQSystemAlertBlock _Nullable)contentCallback
                             cancelCallback:(XQSystemAlertCancelBlock _Nullable)cancelCallback;


/**
 底部弹框, 手动完美适配iPad

 @param sourceView 弹出在那个view上面
 @param sourceRect 弹出的尖点位置, 锚点
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *_Nullable)title
                                    message:(NSString *_Nullable)message
                                 contentArr:(NSArray *_Nullable)contentArr
                                 cancelText:(NSString *_Nullable)cancelText
                                         vc:(UIViewController *_Nullable)vc
                                 sourceView:(UIView *_Nullable)sourceView
                                 sourceRect:(CGRect)sourceRect
                            contentCallback:(XQSystemAlertBlock _Nullable)contentCallback
                             cancelCallback:(XQSystemAlertCancelBlock _Nullable)cancelCallback;



#pragma mark -- 额外的一些方法
/**
 当前是否是弹框
 
 @return YES是弹框在最前面
 */
+ (BOOL)isAlert;

/**
 退出当前弹框
 */
+ (void)alertDismiss;

/**
 改变当前弹框的title
 */
+ (void)changeAlertTitle:(NSString * _Nullable)title;

/**
 改变当前弹框的message
 */
+ (void)changeAlertMessage:(NSString * _Nullable)message;

/**
 改变当前弹框的某个按钮是否可以点击

 @param enabled YES可以点击
 @param index 按钮的下标
 */
+ (void)changeEnabled:(BOOL)enabled index:(NSInteger)index;

/**
 在当前弹框上, 再添加一个按钮

 @param title 按钮标题
 @param callback 点击回调
 */
+ (void)addActionWithTitle:(NSString *_Nonnull)title callback:(XQSystemAlertActionBlock _Nullable)callback;

/**
 在当前弹框上, 添加输入框

 @param callback 设置tf属性回调
 */
+ (void)addTextFieldWithCallback:(XQSystemAlertTextFieldBlock _Nullable)callback;

@end











