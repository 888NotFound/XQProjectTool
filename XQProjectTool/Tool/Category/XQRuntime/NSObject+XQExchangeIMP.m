//
//  NSObject+XQExchangeIMP.m
//  LongBtn
//
//  Created by ladystyle100 on 2017/9/22.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "NSObject+XQExchangeIMP.h"
#import <objc/runtime.h>
//#import <objc/message.h> // 包含消息机制

// 获取imp
//class_getMethodImplementation(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>)

// 替换方法
//class_replaceMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>, <#IMP  _Nonnull imp#>, <#const char * _Nullable types#>)

// 获取method
//class_getClassMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>)
//class_getInstanceMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>)

// 交换method
//method_exchangeImplementations(<#Method  _Nonnull m1#>, <#Method  _Nonnull m2#>)

// 设置imp
//method_setImplementation(<#Method  _Nonnull m#>, <#IMP  _Nonnull imp#>)

@implementation NSObject (XQExchangeIMP)

+ (BOOL)exchangeClassMethodWithOriginSEL:(SEL)originSEL otherSEL:(SEL)otherSEL {
    [self exchangeMethodWithIsClass:YES originSEL:originSEL otherSEL:otherSEL];
    return YES;
}

+ (BOOL)exchangeInstanceMethodWithOriginSEL:(SEL)originSEL otherSEL:(SEL)otherSEL {
    [self exchangeMethodWithIsClass:NO originSEL:originSEL otherSEL:otherSEL];
    return YES;
}

+ (BOOL)exchangeMethodWithIsClass:(BOOL)isClass originSEL:(SEL)originSEL otherSEL:(SEL)otherSEL {
    return [self exchangeMethodWithOriginClass:self originIsClass:isClass originSEL:originSEL otherClass:self otherIsClass:isClass otherSEL:otherSEL];
}

+ (BOOL)exchangeMethodWithOriginClass:(Class)originClass originIsClass:(BOOL)originIsClass originSEL:(SEL)originSEL otherClass:(Class)otherClass otherIsClass:(BOOL)otherIsClass otherSEL:(SEL)otherSEL {
    Method originMethod;
    Method otherMethod;
    
    originMethod = originIsClass ? class_getClassMethod(originClass, originSEL) : class_getInstanceMethod(originClass, originSEL);
    otherMethod = otherIsClass ? class_getClassMethod(otherClass, otherSEL) : class_getInstanceMethod(otherClass, otherSEL);
    
    if (!originMethod) {
        return NO;
    }
    
    if (!otherMethod) {
        return NO;
    }
    
    method_exchangeImplementations(originMethod, otherMethod);
    return YES;
}


+ (void)xq_setAssociatedObject:(id)obj key:(NSString *)key value:(id)value policy:(objc_AssociationPolicy)policy  {
    objc_setAssociatedObject(obj, (__bridge const void * _Nonnull)(key), value, policy);
}

+ (id)xq_getAssociatedObject:(id)obj key:(NSString *)key {
    return objc_getAssociatedObject(obj, (__bridge const void * _Nonnull)(key));
}


@end













