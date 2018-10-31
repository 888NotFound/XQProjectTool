//
//  XQCustomSheetAlertView.h
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQCustomSheetAlertViewCallback)(NSInteger index);

@interface XQCustomSheetAlertView : UIView

+ (void)sheetWithTitle:(NSString *)title message:(NSString *)message dataArr:(NSArray <NSString *> *)dataArr cancelText:(NSString *)cancelText callback:(XQCustomSheetAlertViewCallback)callback cancelCallback:(XQCustomSheetAlertViewCallback)cancalCallback;

+ (void)setItemColorWithColor:(UIColor *)color rows:(NSArray <NSNumber *> *)rows;
+ (void)setItemColorWithColor:(UIColor *)color row:(NSInteger)row;
+ (void)setCancelItemColorWithColor:(UIColor *)color;

@end
