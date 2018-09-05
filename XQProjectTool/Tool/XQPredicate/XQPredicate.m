//
//  XQPredicate.m
//  Appollo4
//
//  Created by WXQ on 2018/5/23.
//  Copyright © 2018年 SyKing. All rights reserved.
//

/**
 symbol介绍
 
 ==, <, >, <=, >=, != ,字符串可用?  = 和 == 意思相同, 习惯性用==罢了
 in, BETWEEN 范围
 BETWEEN {1, 5} // 1 ~ 5
 IN {'哈哈', '嘻嘻'} // 或者直接传入个一个数组.., in也能 {1, 5}, 没试过BETWEEN, 看网上..好像也是IN偏多
 NOT (SELF IN %@) // 不在某个范围内
 
 @"name CONTAINS[cd] 'ang'"   //包含某个字符串
 @"name BEGINSWITH[c] 'sh'"     //以某个字符串开头
 @"name ENDSWITH[d] 'ang'"      //以某个字符串结束
 
 LIKE // 通配符
 LIKE[cd] '*s*' 包含s就可以
 LIKE[cd] 's*' s开头
 LIKE[cd] '*s' s结尾
 LIKE[cd] '?s' ?表示一个字符, 这个表示, 查询第二个是s
 
 [c]不区分大小写, [d]不区分发音, [cd]合并
 */

/**
 多条件查询
 
 SELF.name CONTAINS[c] %@ || SELF.u_id CONTAINS[c] %@
 name='1' && age>40
 */

/**
 一些疑问
 
 self 是代表自身 ?
 如果不是 self, 那么都代表是 key ?
 self.key...看网上有人这么写...那么, 就是意思能替代%K???
 */

#import "XQPredicate.h"

@implementation XQPredicate


/**
 验证是否是正确手机号

 @param phone 手机号
 @return YES正确
 */
+ (BOOL)predicateCheckPhoneWithPhone:(NSString *)phone {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phone];
}

/**
 是否存在特殊字符

 @return YES存在
 */
+ (BOOL)isExistParticularStr:(NSString *)str {
    NSString *regex = @"[^a-zA-Z0-9\u4E00-\u9FA5,.?:;()!{}<>#*-+=，。、？：；（）！{}+=]➋➌➍➎➏➐➑➒";
    NSRange urgentRange = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString: regex]];
    if (urgentRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

/**
 是否存在中文 
 */
+ (BOOL)isContainChineseWithStr:(NSString *)str {
    for(int i=0; i< [str length]; i++){
        int a = [str characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//-(BOOL)IsChinese:(NSString *)str {

//
//}


/**
 查询model某个key的值 ??能用字典查么..应该字典也是用这个吧

 @param dataArr 数据源
 @param value 要查询的值
 @param key 要查询的key
 */
+ (NSArray *)predicateKeyEqWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key {
    return [self predicateKeyWithDataArr:dataArr value:value key:key symbol:@"=="];
}

/**
 查询model, 包含某个值
 */
+ (NSArray *)predicateKeyContainWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key {
    return [self predicateKeyWithDataArr:dataArr value:value key:key symbol:@"contains[cd]"];
}

/**
 查询数组里面 == value 的值
 */
+ (NSArray *)predicateSelfEqWithDataArr:(NSArray *)dataArr value:(id)value {
    return [self predicateSelfWithDataArr:dataArr value:value symbol:@"=="];
}

/**
 查询dataArr1在dataArr2中的相同元素
 */
+ (NSArray *)predicateSelfInWithDataArr1:(NSArray *)dataArr1 dataArr2:(NSArray *)dataArr2 {
    return [self predicateSelfWithDataArr:dataArr1 value:dataArr2 symbol:@"in"];
}

/**
 查询数组里面的值, 这个不能用于model
 */
+ (NSArray *)predicateSelfWithDataArr:(NSArray *)dataArr value:(id)value symbol:(NSString *)symbol {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF %@ %@", symbol, value];
    NSArray *eqArr = [dataArr filteredArrayUsingPredicate:predicate];
    return eqArr;
}

+ (NSArray *)predicateKeyWithDataArr:(NSArray *)dataArr dataArr2:(NSArray *)dataArr2 key:(NSString *)key {
    return [self predicateKeyWithDataArr:dataArr value:dataArr2 key:key symbol:@"in"];
}

/**
 查询数组里面的值

 @param dataArr 数据源, 是model或者dic
 @param value 值
 @param key 寻找的key
 @param symbol 符号, = > < , CONTAIN[cd] 等等
 */
+ (NSArray *)predicateKeyWithDataArr:(NSArray *)dataArr value:(id)value key:(NSString *)key symbol:(NSString *)symbol {
    // 这个和上面的Self...是否能合并成一个?? 就是用 %@ 和 %K 是否同一个效果??
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", @"%K", symbol, @"%@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str, key, value];
    NSArray *eqArr = [dataArr filteredArrayUsingPredicate:predicate];
    return eqArr;
}


@end





















