//
//  NSObject+XQViewOC.h
//  Test
//
//  Created by ladystyle100 on 2017/9/4.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XQViewOC)

/**
 查看类变量名称
 @return 返回变量名称
 */
+ (NSArray *)viewVar;
/**
 查看实例变量名称, 和变量值

 @param callback 返回变量名称和值
 */
- (void)viewVarCallback:(void(^)(NSArray *varNameArr, NSArray *varValueArr))callback;

/** 查看指定类的var
 *  @param xqClass 查看的类
 *  @param obj 查看的对象, 如果不为nil, 则会尝试去获得值打印
 */
+ (void)viewVarWithClass:(Class)xqClass obj:(id)obj callback:(void(^)(NSArray *varNameArr, NSArray *varValueArr))callback;

/**
 查看类属性

 @param callback 返回里面值是没有的
 */
+ (void)viewPropertyWithCallback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback;
/**
 查看实例属性
 */
- (void)viewPropertyWithCallback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback;
/**
 查看属性

 @param obj 存在, 则valueDic会有值
 @param class 查询的类
 */
+ (void)viewPropertyWithObj:(id)obj class:(Class)xqClass callback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback;

/** 查看实例方法 */
+ (void)viewInstanceMethod;
+ (void)viewInstanceMethodWithClass:(Class)xqClass;

/** 查看类方法 */
+ (void)viewClassMethod;
+ (void)viewClassMethodWithClass:(Class)xqClass;

/** 查看遵守协议 */
+ (void)viewProtocol;
+ (void)viewProtocolWithClass:(Class)xqClass;

/** 获取当前所有OC类 */
+ (void)viewCurrentAllClass;

/** 获取当前所有协议 */
+ (void)viewCurrentAllProtocol;

@end














