//
//  NSString+HexadecimalConversion.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/22.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "NSString+HexadecimalConversion.h"

@implementation NSString (HexadecimalConversion)

    // 温湿度
- (NSString *)xq_HTHexadecimalTransferDecimal {
    if (self.length < 2) {
        return @"";
    }
    
        // 这步操作是项目需求
        // 后面的两个字符串
    NSString *a = [self substringFromIndex:self.length - 2];
        // 前面字符串
    NSString *b = [self substringToIndex:self.length - 2];
        // 交换位置
    NSString *str = [NSString stringWithFormat:@"%@%@", a, b];
    
        // /100, 温湿度
    return [NSString stringWithFormat:@"%.2f", [NSString xq_hexadecimalTransferDecimalWithStr:str].floatValue/100.0];
}

- (NSString *)xq_hexadecimalTransferDecimal {
    return [NSString xq_hexadecimalTransferDecimalWithStr:self];
}

+ (NSString *)xq_hexadecimalTransferDecimalWithStr:(NSString *)str {
    if (str.length == 0) {
        return @"0";
    }
        // 转换
    NSScanner * scanner = [NSScanner scannerWithString:str];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
        //将整数转换为NSNumber,存储到数组中,并返回.
    return [NSString stringWithFormat:@"%lld", longlongValue];
}

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    return [self getBinaryByDecimal:decimal length:4];
}

/**
 十六转换为二
 
 @param hexadecimal 十六
 @param length 保留多少位
 @return 二进制数
 */
+ (NSString *)getBinaryWithHexadecimal:(NSString *)hexadecimal length:(int)length {
    NSString *str = [self xq_hexadecimalTransferDecimalWithStr:hexadecimal];
    return [self getBinaryByDecimal:str.integerValue length:length];
}

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @param length 保留多少位
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal length:(int)length {
    NSString *a = @"";
    while (decimal) {
        a = [[NSString stringWithFormat:@"%d", (int)decimal%2] stringByAppendingString:a];
        if (decimal/2 < 1) {
            break;
        }
        decimal = decimal/2 ;
    }
    
    if (a.length < length) {
            // 小于长度, 补零
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++) {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
        
    }else if (a.length > length) {
            // 大于长度, 截取
        a = [a substringWithRange:NSMakeRange(a.length - length, length)];
    }
    
    return a;
}



    // 默认补4位
+ (NSString *)toHexInt:(long long int)tmpid {
    return [self toHexInt:tmpid complement:4];
}

/**
 10 int 转 16 str
 
 @param tmpid 10进制
 @return 16进制字符串
 */
+ (NSString *)toHexInt:(long long int)tmpid complement:(NSInteger)complement {
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i =0; i<9; i++) {
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc] initWithFormat:@"%lli",ttmpig];
        }
        
        str = [nLetterValue stringByAppendingString:str];
        
        if (tmpid == 0) {
            break;
        }
    }
    
    if (str.length >= complement) {
        return str;
    }
    
        // 补0
    NSInteger count = complement - str.length;
    for (int i = 0; i < count; i++) {
        str = [@"0" stringByAppendingString:str];
    }
    
    return str;
}

@end











