//
//  NSString+SmallMethod.h
//  XQProjectTool
//
//  Created by WXQ on 2018/5/15.
//  Copyright © 2018年 SyKing. All rights reserved.
//

// 一些额外小方法

#import <Foundation/Foundation.h>

@interface NSString (SmallMethod)

/**
 验证是否是手机号码
 @return YES是, NO不是
 */
- (BOOL)xq_evaluatePhoneNumber;

@end
