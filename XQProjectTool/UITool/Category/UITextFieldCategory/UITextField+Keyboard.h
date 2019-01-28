//
//  UITextField+Keyboard.h
//  Appollo4
//
//  Created by WXQ on 2018/7/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQUITextFieldCallback)(void);

@interface UITextField (Keyboard)

/** 点击删除按钮 */
@property (nonatomic, copy) XQUITextFieldCallback delCallback;

@end
