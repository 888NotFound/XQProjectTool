//
//  NSString+XQHTMLFilter.m
//  XQMacOCTableView
//
//  Created by WXQ on 2018/8/1.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "NSString+XQHTMLFilter.h"

@implementation NSString (XQHTMLFilter)

+ (NSString *)xq_filterWithStartLabel:(NSString *)startLabel endLabel:(NSString *)endLabel content:(NSString *)content {
    if (content.length == 0 || startLabel.length == 0 || endLabel.length == 0) {
        NSLog(@"参数错误");
        return @"";
    }
    
    NSRange sRange = [content rangeOfString:startLabel];
    NSRange eRange = [content rangeOfString:endLabel];
    
    NSInteger location = sRange.location + sRange.length;
    NSInteger length = eRange.location - location;
    if (length < 0) {
        NSLog(@"长度错误");
        return @"";
    }
    
    return [content substringWithRange:NSMakeRange(location, length)];
}

@end















