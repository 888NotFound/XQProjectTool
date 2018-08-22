//
//  NSString+XQHTMLFilter.h
//  XQMacOCTableView
//
//  Created by WXQ on 2018/8/1.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XQHTMLFilter)

/**
 传入对应标签, 获取内容
 问题: 只会获取第一个, 并且获取的内容里面也可能存在标签...不会自动去过滤

 @param startLabel 开始标签
 @param endLabel 结束标签
 @param content html内容
 @return 过滤完的内容
 */
+ (NSString *)xq_filterWithStartLabel:(NSString *)startLabel endLabel:(NSString *)endLabel content:(NSString *)content;

@end



















