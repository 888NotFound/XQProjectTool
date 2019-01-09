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
 是否存在中文
 
 @return YES存在
 */
+ (BOOL)isContainChineseWithStr:(NSString *)str;

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

/**
 查询字典, 或者Model, 相同元素
 
 @param dataArr 字典或者model
 @param dataArr2 数组, 里面要包含的值
 @param key dataArr的 字段 or key
 */
+ (NSArray *)predicateKeyWithDataArr:(NSArray *)dataArr dataArr2:(NSArray *)dataArr2 key:(NSString *)key;

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
