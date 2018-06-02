//
//  NSString+XOR.m
//  MQTTProject
//
//  Created by WXQ on 2018/4/24.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "NSString+XOR.h"
#import "NSString+XQCRC.h"

@implementation NSString (XOR)

- (NSString *)xq_doorLockXOR {
    if (self.length != 6) {
        NSLog(@"密码长度不对");
        return self;
    }
    
    //加密密钥...这样放到数组里面, 取出时..是十进制
    NSArray *arr = @[@0x46, @0x45, @0x49, @0x42, @0x49, @0x47];
    
    NSString *str = @"";
    for (int i = 0; i < arr.count; i++) {
        int number = [self substringWithRange:NSMakeRange(i, 1)].intValue ^ [arr[i] intValue];
        str = [str stringByAppendingString:[NSString toHexInt:number complement:2]];
    }
    
    NSLog(@"%@", str);
    // 转为全部小写
    return [str lowercaseString];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    char *dataB = (char *)[data bytes];
    for (int i = 0; i < arr.count; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        *dataB = *(++dataB) ^ [arr[i] intValue];
#pragma clang diagnostic pop
    }
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", result);
    return result;
}

@end










