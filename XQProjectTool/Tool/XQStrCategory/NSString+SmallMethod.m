//
//  NSString+SmallMethod.m
//  XQProjectTool
//
//  Created by WXQ on 2018/5/15.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "NSString+SmallMethod.h"

@implementation NSString (SmallMethod)

- (BOOL)xq_evaluatePhoneNumber {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

@end
