//
//  NSArray+XQFilter.h
//  XQMacOCTableView
//
//  Created by WXQ on 2018/8/3.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (XQFilter)

/**
 根据某个key过滤数组, 并返回过滤好的数组
 过滤规则: 这个key相等的, 则组为一组数组

 @param arr Model, 或者Dic
 @param key 过滤的key
 @return
 @[
 
 @[
 相等数据
 ],
 
 @[
 相等数据
 ],
 
 ]
 */
+ (NSArray *)xq_filterWithArr:(NSArray *)arr key:(NSString *)key;

@end
