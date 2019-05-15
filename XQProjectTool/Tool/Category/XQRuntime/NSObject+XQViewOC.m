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
#define XQLog(...) NSLog(__VA_ARGS__)
#else
#define XQLog(...) {}
#endif

@implementation NSObject (XQViewOC)

+ (NSArray <XQRuntimeModel *> *)xq_viewVar {
    return [self xq_viewVarWithClass:self obj:nil];
}

- (NSArray <XQRuntimeModel *> *)xq_viewVar {
    return [[self class] xq_viewVarWithClass:[self class] obj:self];
}

+ (NSArray <XQRuntimeModel *> *)xq_viewVarWithClass:(Class)xqClass obj:(id)obj {
    // 属性名称arr
    NSMutableArray *modelArr = [NSMutableArray array];
    
    // 实例变量的偏移量为：8、16、24、32、40；呈递增趋势，规律为 index * 8 (index > 0)；偏移量理解为“索引"
    // 个数
    unsigned int count = 0;
    // 获取值列表
    Ivar *ivars = class_copyIvarList(xqClass, &count);
    for (int i = 0; i < count; i++) {
        XQRuntimeModel *model = [XQRuntimeModel new];
        
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *encoding = ivar_getTypeEncoding(ivar);
        // 偏移量
//        ptrdiff_t offset = ivar_getOffset(ivar);
        id value = nil;
        if (obj) {
            value = object_getIvar(obj, ivar);
            
            model.xq_value = value;
        }
        
        
        model.xq_name = [NSString stringWithUTF8String:name];
        model.xq_encoding = [NSString stringWithUTF8String:encoding];
        [modelArr addObject:model];
    }
    
    free(ivars);
    
    return modelArr;
}

#pragma mark -- 属性

+ (NSArray <XQRuntimeModel *> *)xq_viewProperty {
    return [self xq_viewPropertyWithObj:nil];
}

- (NSArray <XQRuntimeModel *> *)xq_viewProperty {
    return [[self class] xq_viewPropertyWithObj:self];
}

+ (NSArray <XQRuntimeModel *> *)xq_viewPropertyWithObj:(id)obj {
    if (obj) {
        return [self xq_viewPropertyWithObj:obj class:[obj class]];
    }
    return [self xq_viewPropertyWithObj:nil class:self];
}

+ (NSArray <XQRuntimeModel *> *)xq_viewPropertyWithObj:(id)obj class:(Class)xqClass {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    unsigned int count = 0;
        // 获取属性列表
    objc_property_t *propertys = class_copyPropertyList(xqClass, &count);
    
    for (int i = 0; i < count; i++) {
        XQRuntimeModel *model = [XQRuntimeModel new];
        
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        model.xq_name = nameStr;
            //(@"property attributes = %s", property_getAttributes(property));
        if (obj) {
            id value = [obj valueForKey:nameStr];
            model.xq_value = value;
                //XQLog(@"property Associated = %@", objc_getAssociatedObject(obj, name));
        }
        
        /** 获取属性列表 */
        unsigned int otherCount = 0;
        objc_property_attribute_t *atts = property_copyAttributeList(property, &otherCount);
        for (int i = 0; i < otherCount; i++) {
            objc_property_attribute_t att = atts[i];
                //char *value = property_copyAttributeValue(property, att.name);//等价于att.value
            const char *value = att.value;
            if (!(strcmp(att.name, "T"))) {
                // T 为属性类型
                model.xq_encoding = [NSString stringWithUTF8String:value];
                break;
            }
        }
        
        [modelArr addObject:model];
        
        free(atts);
    }
    
    free(propertys);
    
    return modelArr;
}

+ (NSArray <XQRuntimeModel *> *)xq_viewAllPropertyWithObj:(id)obj class:(Class)xqClass {
    return [self xq_viewAllPropertyWithObj:obj class:xqClass stopClass:[NSObject class]];
}

+ (NSArray <XQRuntimeModel *> *)xq_viewAllPropertyWithObj:(id)obj class:(Class)xqClass stopClass:(Class)stopClass {
    if (!stopClass) {
        stopClass = [NSObject class];
    }
    
    NSMutableArray *modelArr = [NSMutableArray new];
    
    Class c = xqClass;
    
    while (1) {
        
        if ([c isEqual:stopClass] || [c isEqual:[NSObject class]] || !c) {
            // 停止遍历
            break;
        }
        
        [modelArr addObjectsFromArray:[self xq_viewPropertyWithObj:obj class:c]];
        c = [c superclass];
    }
    
    return modelArr;
}

#pragma mark -- 方法

+ (void)xq_viewInstanceMethod {
    [self xq_viewMethodWithClass:[self class]];
}

+ (void)xq_viewClassMethod {
    Class class = objc_getMetaClass(class_getName(self));
    [self xq_viewMethodWithClass:class];
}

+ (void)xq_viewInstanceMethodWithClass:(Class)xqClass {
    [self xq_viewMethodWithClass:xqClass];
}

+ (void)xq_viewClassMethodWithClass:(Class)xqClass {
    // 获取元类, 类方法 +号方法, 如果不是元类, 就是获取实例方法
    Class class = objc_getMetaClass(class_getName(xqClass));
    [self xq_viewMethodWithClass:class];
}

+ (void)xq_viewMethodWithClass:(Class)xqClass {
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
        
        XQLog(@"%@ name = %@, encoding = %s", head, name, encoding);
        
        /** 返回值代表类型(参数也是和这表达一样的), 这只是一部分, 有道存着, 也可以百度runtimeTypeEncoding
         *  v: void
         *  i: int
         *  f: float
         */
        //XQLog(@"returnType = %s", method_copyReturnType(*method));
        
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
            //XQLog(@"参数位置 = %d, argType = %s", j, method_copyArgumentType(*method, j));
        }
        
        /** 方法描述描述
         *  name: 方法名
         *  types: 返回值
         */
        //struct objc_method_description description = *method_getDescription(*method);
        //XQLog(@"description name = %@, type = %s", NSStringFromSelector(description.name), description.types);
        
    }
    
    free(methods);
}

+ (void)xq_viewProtocol {
    [self xq_viewProtocolWithClass:self];
}

+ (void)xq_viewProtocolWithClass:(Class)xqClass {
    unsigned int outCount = 0;
    // 必须释放指针 free
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(xqClass, &outCount);
    [self xq_viewProtocolWithProtocols:protocols outCount:outCount];
}

+ (void)xq_viewProtocolWithProtocols:(Protocol * __unsafe_unretained *)protocols outCount:(unsigned int)outCount {
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
        XQLog(@"protocol name = %s", protocol_getName(protocol));
    }
    
    // 释放指针
    free(protocols);
}

+ (void)xq_viewCurrentAllClass {
    unsigned int outCount = 0;
    Class *classTotal = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class class = classTotal[i];
        XQLog(@"className = %s", class_getName(class));
    }
    free(classTotal);
}

+ (void)xq_viewCurrentAllProtocol {
    unsigned int outCount = 0;
    Protocol * __unsafe_unretained *protocols = objc_copyProtocolList(&outCount);
    [self xq_viewProtocolWithProtocols:protocols outCount:outCount];
}



@end



















