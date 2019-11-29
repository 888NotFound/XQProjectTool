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


+ (NSArray *)xq_filterWithArr:(NSArray *)arr key:(NSString *)key {
    if (key.length == 0 || arr.count == 0) {
        return @[];
    }
    
    if (arr.count == 1) {
        return @[arr];
    }
    
    NSMutableArray *muArr = arr.mutableCopy;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    while (muArr.count != 0) {
        id value = nil;
        if ([muArr.firstObject isKindOfClass:[NSDictionary class]]) {
            value = muArr.firstObject[key];
        }else {
            value = [muArr.firstObject valueForKey:key];
        }
        NSArray *fArr = [XQPredicate predicateKeyEqWithDataArr:muArr value:value key:key];
        [muArr removeObjectsInArray:fArr];
        [resultArr addObject:fArr];
    }
    
    return resultArr;
}

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
 验证邮箱格式是否正确

 @param email 邮箱
 @return YES正确
 */
+ (BOOL)predicateCheckEMailWithEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 验证身份证是否合法

 @param Id 身份证
 @return YES 合法
 */
+ (BOOL)predicateCheckCNIDCardWithId:(NSString *)Id {
    NSString *str = Id;
    
    //长度不为18的都排除掉
    if (str.length != 18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:str];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[str substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [str substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    return NO;
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

//判断是否银行卡

+ (BOOL)isBankCard:(NSString *)cardNo {
    
    if (cardNo.length < 16) {
        return NO;
    }

    int oddsum = 0;    //奇数求和

    int evensum = 0;    //偶数求和

    int allsum = 0;

    int cardNoLength = (int)cardNo.length;

    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength -1];

    for (int i = cardNoLength -1 ; i>=1;i--) {

        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];

        int tmpVal = [tmpString intValue];

        if (cardNoLength % 2 ==1 ) {

            if((i % 2) == 0){

                tmpVal *= 2;

                if(tmpVal>=10)

                    tmpVal -= 9;

                evensum += tmpVal;

            }else{

                oddsum += tmpVal;

            }

        }else{

            if((i % 2) == 1){

                tmpVal *= 2;

                if(tmpVal>=10)

                    tmpVal -= 9;

                evensum += tmpVal;

            }else{

                oddsum += tmpVal;

            }

        }

    }

    

    allsum = oddsum + evensum;

    allsum += lastNum;

    
        
    if ((allsum % 10) ==0) {
        return YES;
    }
            
    return NO;
}

// 判断是否全部为数字
+ (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

// 是否全部为中文
+ (BOOL)inputShouldChinese:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

// 是否全部为字母
+ (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


/**
 查询model某个key的值

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





















