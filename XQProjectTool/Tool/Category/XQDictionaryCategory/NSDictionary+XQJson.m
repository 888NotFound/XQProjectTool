//
//  NSDictionary+XQJson.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/26.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "NSDictionary+XQJson.h"

@implementation NSDictionary (XQJson)

+ (NSString *)jsonStrWithDic:(id)dic {
    if (dic == nil) {
        return @"";
    }
    
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if(err) {
        NSLog(@"error = %@", err);
        return @"";
    }
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str ? str : @"";
}

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

@end











