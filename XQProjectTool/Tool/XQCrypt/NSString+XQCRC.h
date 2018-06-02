//
//  NSString+XQCRC.h
//  MQTTProject
//
//  Created by WXQ on 2018/4/23.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XQCRC)

/**
 获取校验码
 字符串: 指令头 ~ 操作数据
 
 @return 16进制字符串
 */
- (NSString *)lmCrc16;

/**
 10 int 转 16 str
 默认补0四位
 @param tmpid 10进制
 @return 16进制字符串
 */
+ (NSString *)toHexInt:(long long int)tmpid;

/**
 10 int 转 16 str
 
 @param complement 补几位, 至少1位, 填0也默认1
 @return 16进制字符串
 */
+ (NSString *)toHexInt:(long long int)tmpid complement:(NSInteger)complement;

@end
