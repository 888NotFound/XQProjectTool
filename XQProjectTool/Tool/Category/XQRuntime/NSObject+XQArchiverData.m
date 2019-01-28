//
//  NSObject+ArchiverData.m
//  Runtime
//
//  Created by ladystyle100 on 2017/6/9.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "NSObject+XQArchiverData.h"
#import "NSObject+XQExchangeIMP.h"


@implementation NSObject (XQArchiverData)

- (void)decoder:(NSCoder *)coder {
    [self coder:coder isDecoder:YES];
}

- (void)encoder:(NSCoder *)coder {
    [self coder:coder isDecoder:NO];
}

/** isDecoder: 是否解档 */
- (void)coder:(NSCoder *)coder isDecoder:(BOOL)isDecoder {
    // 获取该属性的个数 unsigned int: 无符号整形
    unsigned int count = 0;
    // 获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i =0; i < count; i ++) {
        // 根据objc_property_t获得其属性的名称--->C语言的字符串
        objc_property_t property = properties[i];
        // 解码每个属性,利用kVC取出每个属性对应的数值
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        
        // 是否解档
        if (isDecoder) {
            // 获取值
            id value = [coder decodeObjectForKey:key];
            // 设置属性值
            [self setValue:value forKeyPath:key];
            
        }else {
            id value = [self valueForKeyPath:key];
            
            // 是否遵守了归档协议
            if ([value conformsToProtocol:@protocol(NSCoding)]) {
                // 归档值
                [coder encodeObject:value forKey:key];
            }
            
        }
    }
    
    // 释放
    free(properties);
}

@end












