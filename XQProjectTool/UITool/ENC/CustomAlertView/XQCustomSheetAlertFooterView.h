//
//  XQCustomSheetAlertFooterView.h
//  Appollo4
//
//  Created by WXQ on 2018/6/21.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQCustomSheetAlertFooterViewCallback)(void);

@interface XQCustomSheetAlertFooterView : UIView

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, copy) XQCustomSheetAlertFooterViewCallback callback;

@end
