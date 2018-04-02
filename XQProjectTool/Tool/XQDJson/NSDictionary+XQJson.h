//
//  NSDictionary+XQJson.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/26.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XQJson)

/**
 字典或者数组转json字符串
 */
+ (NSString *)jsonStrWithDic:(id)dic;

/**
 json字符串转字典或数组
 */
+ (id)dictionaryWithJsonString:(NSString *)jsonString;

@end
