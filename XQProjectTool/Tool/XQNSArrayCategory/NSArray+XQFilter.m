//
//  NSArray+XQFilter.m
//  XQMacOCTableView
//
//  Created by WXQ on 2018/8/3.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "NSArray+XQFilter.h"
#import "XQPredicate.h"

@implementation NSArray (XQFilter)

+ (NSArray *)xq_filterWithArr:(NSArray *)arr key:(NSString *)key {
    if (key.length == 0) {
        return @[];
    }
    
    if (arr.count == 0 || arr.count == 1) {
        return arr;
    }
    
    NSMutableArray *muArr = arr.mutableCopy;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    while (muArr.count != 0) {
        id value = nil;
        if ([muArr.firstObject isKindOfClass:[NSDictionary class]]) {
            value = muArr.firstObject[key];
        }else {
            value = [muArr.firstObject valueForKey:key];
        }
        NSArray *fArr = [XQPredicate predicateKeyEqWithDataArr:muArr value:value key:key];
        [muArr removeObjectsInArray:fArr];
        [resultArr addObject:fArr];
    }
    
    return resultArr;
}

@end
