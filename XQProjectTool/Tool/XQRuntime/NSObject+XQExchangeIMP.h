//
//  NSObject+XQExchangeIMP.h
//  LongBtn
//
//  Created by ladystyle100 on 2017/9/22.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (XQExchangeIMP)

/** 调用类(调用该方法的类), 交换类方法
 *  return NO失败
 */
+ (BOOL)exchangeClassMethodWithOriginSEL:(SEL)originSEL
                                otherSEL:(SEL)otherSEL;
/** 调用类, 交换实例方法 */
+ (BOOL)exchangeInstanceMethodWithOriginSEL:(SEL)originSEL
                                   otherSEL:(SEL)otherSEL;

/** 交换方法
 *  @param originClass originSEL的类
 *  @param originIsClass YES类方法, NO实例方法
 *  return NO失败
 *
 *  这个是可以交换不同的类的方法, 比如Dic和Arr, 就可以交换他们的add, 不过应该没人会这么做。。。
 */
+ (BOOL)exchangeMethodWithOriginClass:(Class)originClass
                        originIsClass:(BOOL)originIsClass
                            originSEL:(SEL)originSEL
                           otherClass:(Class)otherClass
                         otherIsClass:(BOOL)otherIsClass
                             otherSEL:(SEL)otherSEL;

/**
 关联值, 可用在category属性关联值

 @param obj 关联对象
 @param key 关联key
 @param value 关联值
 @param policy 关联的方式
 */
+ (void)xq_setAssociatedObject:(id)obj key:(NSString *)key value:(id)value policy:(objc_AssociationPolicy)policy;

/**
 获取关联的值
 */
+ (id)xq_getAssociatedObject:(id)obj key:(NSString *)key;

@end











