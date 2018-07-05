//
//  XQPredicate.h
//  Appollo4
//
//  Created by WXQ on 2018/5/23.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQPredicate : NSObject

/**
 验证是否是正确手机号
 
 @param phone 手机号
 @return YES正确
 */
+ (BOOL)predicateCheckPhoneWithPhone:(NSString *)phone;

/**
 是否存在特殊字符
 
 @return YES存在
 */
+ (BOOL)isExistParticularStr:(NSString *)str;

/**
 查询model or dictionary某个key的值
 
 @param dataArr 数据源
 @param value 要查询的值
 @param key 要查询的key
 */
+ (NSArray *)predicateKeyEqWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key;

/**
 查询model, 包含某个值
 */
+ (NSArray *)predicateKeyContainWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key;

/**
 查询数组里面的值
 */
+ (NSArray *)predicateSelfEqWithDataArr:(NSArray *)dataArr value:(id)value;

/**
 查询dataArr1在dataArr2中的相同元素
 */
+ (NSArray *)predicateSelfInWithDataArr1:(NSArray *)dataArr1 dataArr2:(NSArray *)dataArr2;


#pragma mark -- 基础方法
/**
 查询数组里面的值, 这个不能用于model和dic
 
 @param dataArr 数据源, 一般是 @[@"1"], 或者@[@(1)]
 @param value 值
 @param symbol 符号, = > < , CONTAIN[cd] 等等
 */
+ (NSArray *)predicateSelfWithDataArr:(NSArray *)dataArr value:(id)value symbol:(NSString *)symbol;

/**
 查询数组里面的值
 
 @param dataArr 数据源, 是model或者dic
 @param value 值
 @param key 寻找的key
 @param symbol 符号, = > < , CONTAIN[cd] 等等
 */
+ (NSArray *)predicateKeyWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key symbol:(NSString *)symbol;

@end
