//
//  NSObject+XQViewOC.m
//  Test
//
//  Created by ladystyle100 on 2017/9/4.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "NSObject+XQViewOC.h"
/** 定义了runtime的类型和方法，类型有：类、对象、方法、实例变量、属性、分类、协议等等；方法有三个前缀的：objc_ 、class_ 、object_ */
#import <objc/runtime.h>
/** 定义了oc消息机制的一些方法：最主要的是objc_msgSend() 调用方法 */
//#import <objc/message.h>

#ifdef DEBUG
#define WLOG(...) NSLog(__VA_ARGS__)
#else
#define WLOG(...)
#endif

@implementation NSObject (XQViewOC)

+ (NSArray *)viewVar {
    __block NSArray *arr = @[];
    [self viewVarWithClass:self obj:nil callback:^(NSArray *varNameArr, NSArray *varValueArr) {
        arr = varNameArr;
    }];
    return arr;
}

- (void)viewVarCallback:(void(^)(NSArray *varNameArr, NSArray *varValueArr))callback {
    [[self class] viewVarWithClass:[self class] obj:self callback:callback];
}

+ (void)viewVarWithClass:(Class)xqClass obj:(id)obj callback:(void(^)(NSArray *varNameArr, NSArray *varValueArr))callback {
    // 属性名称arr
    NSMutableArray *varNameArr = [NSMutableArray array];
        // 属性值arr
    NSMutableArray *varValueArr = [NSMutableArray array];
    
    // 实例变量的偏移量为：8、16、24、32、40；呈递增趋势，规律为 index * 8 (index > 0)；偏移量理解为“索引"
    // 个数
    unsigned int count = 0;
    // 获取值列表
    Ivar *ivars = class_copyIvarList(xqClass, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *encoding = ivar_getTypeEncoding(ivar);
        ptrdiff_t offset = ivar_getOffset(ivar);
        id value = nil;
        if (obj) {
            value = object_getIvar(obj, ivar);
            [varValueArr addObject:value];
        }
        
        [varNameArr addObject:[NSString stringWithUTF8String:name]];
        WLOG(@"ivar name = %s, encoding = %s, offset = %td, value = %@", name, encoding, offset, value);
    }
    
    free(ivars);
    
    if (callback) {
        callback(varNameArr, varValueArr);
    }
}

#pragma mark -- 属性

+ (void)viewPropertyWithCallback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback {
    [self viewPropertyWithObj:nil callback:callback];
}

- (void)viewPropertyWithCallback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback {
    [[self class] viewPropertyWithObj:self callback:callback];
}

+ (void)viewPropertyWithObj:(id)obj callback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback {
    [self viewPropertyWithObj:obj class:self callback:callback];
}

+ (void)viewPropertyWithObj:(id)obj class:(Class)xqClass callback:(void(^)(NSArray *nameArr, NSArray *typeArr, NSDictionary *valueDic))callback {
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
        // 获取属性列表
    objc_property_t *propertys = class_copyPropertyList(xqClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [nameArr addObject:nameStr];
            //WLOG(@"property attributes = %s", property_getAttributes(property));
        if (obj) {
            id value = [obj valueForKey:nameStr];
            [valueDic addEntriesFromDictionary:@{
                                                 nameStr: value ? value : @"",
                                                 }];
                //WLOG(@"property Associated = %@", objc_getAssociatedObject(obj, name));
        }
        
        /** 获取属性列表 */
        unsigned int otherCount = 0;
        objc_property_attribute_t *atts = property_copyAttributeList(property, &otherCount); //获取属性特性列表
        for (int i = 0; i < otherCount; i++) {
            objc_property_attribute_t att = atts[i];
                //char *value = property_copyAttributeValue(property, att.name);//等价于att.value
            const char *value = att.value;
                //WLOG(@"property 特性 -- 名称为：%s -- 值为：%s --", att.name, value);
            if (!(strcmp(att.name, "T"))) {
                [typeArr addObject:[NSString stringWithUTF8String:value]];
                break;
            }
        }
        
        free(atts);
    }
    
    free(propertys);
    
    if (callback) {
        callback(nameArr, typeArr, valueDic);
    }
}

#pragma mark -- 方法

+ (void)viewInstanceMethod {
    [self viewMethodWithClass:self];
}

+ (void)viewClassMethod {
    Class class = objc_getMetaClass(class_getName(self));
    [self viewMethodWithClass:class];
}

+ (void)viewInstanceMethodWithClass:(Class)xqClass {
    [self viewMethodWithClass:xqClass];
}

+ (void)viewClassMethodWithClass:(Class)xqClass {
    // 获取元类, 类方法 +号方法, 如果不是元类, 就是获取实例方法
    Class class = objc_getMetaClass(class_getName(xqClass));
    [self viewMethodWithClass:class];
}

+ (void)viewMethodWithClass:(Class)xqClass {
    NSString *head = @"instance method";
    
    // 是否元类
    if (class_isMetaClass(xqClass)) {
        head = @"class method";
    }
    
    unsigned int count = 0;
    Method *methods = class_copyMethodList(xqClass, &count);
    
    for (int i = 0; i < count; i++) {
        Method *method = &methods[i];
        NSString *name = NSStringFromSelector(method_getName(*method));
        /** 组成
         *  q16@0:8   : q(返回值)16(返回值偏移量)@(调用方法者)0(调用方法者偏移量):(方法)8(方法偏移量)
         *
         *  调用 0, 方法 8, 返回值 16
         *  偏移量规则: 调用者0 -> 参数count * 8 -> 返回值 + 8
         *  实例变量的偏移量为：8、16、24、32、40；呈递增趋势，规律为 index * 8 (index > 0)；偏移量理解为“索引”
         */
        // 获取方法 返回值、调用者、参数
        const char *encoding = method_getTypeEncoding(*method);
        
        WLOG(@"%@ name = %@, encoding = %s", head, name, encoding);
        
        /** 返回值代表类型(参数也是和这表达一样的), 这只是一部分, 有道存着, 也可以百度runtimeTypeEncoding
         *  v: void
         *  i: int
         *  f: float
         */
        //WLOG(@"returnType = %s", method_copyReturnType(*method));
        
        // 获取imp(实现方法)
        //IMP methodIMP = method_getImplementation(*method);
        
        // 获取参数个数
        int methodArgCount = method_getNumberOfArguments(*method);
        for (int j = 0; j < methodArgCount; j++) {
            /** 获取参数类型, 一般默认有两个:调用类型 和 SEL
             *  0: 调用类型, 就是什么类调用了这个方法
             *  1: 一直都是这个符号( : )
             *  2: 第一个参数..下面接着循环
             */
            //WLOG(@"参数位置 = %d, argType = %s", j, method_copyArgumentType(*method, j));
        }
        
        /** 方法描述描述
         *  name: 方法名
         *  types: 返回值
         */
        //struct objc_method_description description = *method_getDescription(*method);
        //WLOG(@"description name = %@, type = %s", NSStringFromSelector(description.name), description.types);
        
    }
    
    free(methods);
}

+ (void)viewProtocol {
    [self viewProtocolWithClass:self];
}

+ (void)viewProtocolWithClass:(Class)xqClass {
    unsigned int outCount = 0;
    // 必须释放指针 free
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(xqClass, &outCount);
    [self viewProtocolWithProtocols:protocols outCount:outCount];
}

+ (void)viewProtocolWithProtocols:(Protocol * __unsafe_unretained *)protocols outCount:(unsigned int)outCount {
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
        WLOG(@"protocol name = %s", protocol_getName(protocol));
    }
    
    // 释放指针
    free(protocols);
}

+ (void)viewCurrentAllClass {
    unsigned int outCount = 0;
    Class *classTotal = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class class = classTotal[i];
        WLOG(@"className = %s", class_getName(class));
    }
    free(classTotal);
}

+ (void)viewCurrentAllProtocol {
    unsigned int outCount = 0;
    Protocol * __unsafe_unretained *protocols = objc_copyProtocolList(&outCount);
    [self viewProtocolWithProtocols:protocols outCount:outCount];
}



@end



















