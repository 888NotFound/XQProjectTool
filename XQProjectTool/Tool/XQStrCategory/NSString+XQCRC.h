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

@end
