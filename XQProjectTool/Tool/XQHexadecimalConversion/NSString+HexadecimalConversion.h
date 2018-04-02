//
//  NSString+HexadecimalConversion.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/22.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexadecimalConversion)

/**
 16转10, self是16进制字符串
 */
- (NSString *)xq_hexadecimalTransferDecimal;;

/**
 10 转 2进制
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

@end
