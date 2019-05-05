//
//  NSObject+XQViewOC.h
//  Test
//
//  Created by ladystyle100 on 2017/9/4.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQRuntimeModel.h"

@interface NSObject (XQViewOC)

#pragma mark - 变量

/** 查看指定类的var
 *  @param xqClass 查看的类
 *  @param obj 查看的对象, 如果不为nil, 则会尝试去获得值打印
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewVarWithClass:(Class)xqClass obj:(id)obj;

/**
 查看类变量
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewVar;

/**
 查看实例变量名称, 和变量值
 */
- (NSArray <XQRuntimeModel *> *)xq_viewVar;

#pragma mark - 属性

/**
 查看类属性
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewProperty;
/**
 查看实例属性
 */
- (NSArray <XQRuntimeModel *> *)xq_viewProperty;

/**
 查看属性 (注意, 这里只查当前类)

 @param obj 存在, model.xq_value 会有值
 @param xqClass 查询的类
 
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewPropertyWithObj:(id)obj class:(Class)xqClass;

/**
 查看所有属性 (包括父类, 一直遍历上去, 直到 NSObject 停止)

 @param obj 存在, model.xq_value 会有值
 @param xqClass 查询的类
 
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewAllPropertyWithObj:(id)obj class:(Class)xqClass;

/**
 查看所有属性 (包括父类, 一直遍历上去, 直到遇到 stopClass 停止, 或者 NSObject 停止)
 
 @param obj 存在, model.xq_value 会有值
 @param xqClass 查询的类
 
 */
+ (NSArray <XQRuntimeModel *> *)xq_viewAllPropertyWithObj:(id)obj class:(Class)xqClass stopClass:(Class)stopClass;

#pragma mark - 方法

/** 查看实例方法 */
+ (void)xq_viewInstanceMethod;
+ (void)xq_viewInstanceMethodWithClass:(Class)xqClass;

/** 查看类方法 */
+ (void)xq_viewClassMethod;
+ (void)xq_viewClassMethodWithClass:(Class)xqClass;

#pragma mark - 协议

/** 查看遵守协议 */
+ (void)xq_viewProtocol;
+ (void)xq_viewProtocolWithClass:(Class)xqClass;

#pragma mark - 其他

/** 获取当前所有OC类 */
+ (void)xq_viewCurrentAllClass;

/** 获取当前所有协议 */
+ (void)xq_viewCurrentAllProtocol;

@end














