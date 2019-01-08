//
//  XQUD.m
//  MacApp
//
//  Created by WXQ on 2018/1/17.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQUD.h"

@implementation XQUD

+ (NSArray *)getIPArr {
    return [self getUDArrWithKey:@"ipArr"];
}

+ (void)deleteIP:(NSString *)ip {
    [self deleteUDWithValue:ip key:@"ipArr"];
}

+ (void)saveIP:(NSString *)ip {
    [self saveUDWithValue:ip key:@"ipArr"];
}

+ (NSArray *)getPortArr {
    return [self getUDArrWithKey:@"portArr"];
}

+ (void)savePort:(NSString *)port {
    [self saveUDWithValue:port key:@"portArr"];
}


/**
 获取保存的数组

 @param key 保存的key
 */
+ (NSArray *)getUDArrWithKey:(NSString *)key {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return arr ? arr : @[];
}

/**
 删除数组某个值
 
 @param value 保存的值
 @param key 保存的key
 */
+ (void)deleteUDWithValue:(id)value key:(NSString *)key {
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (arr) {
        [muArr addObjectsFromArray:arr];
    }
    
    [muArr removeObject:value];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:key];
}

/**
 添加一个值到数组里

 @param value 保存的值
 @param key 保存的key
 */
+ (void)saveUDWithValue:(id)value key:(NSString *)key {
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (arr) {
        [muArr addObjectsFromArray:arr];
    }
    
    [muArr addObject:value];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:key];
}

@end


















