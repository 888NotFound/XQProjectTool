//
//  NSString+XQCategory.m
//  Pods-XQTestEqual
//
//  Created by WXQ on 2019/4/24.
//

#import "NSString+XQCategory.h"
#import "XQPredicate.h"

@implementation NSString (XQCategory)


+ (NSArray *)xq_filterDataWithDataArr:(NSArray *)dataArr filterKey:(NSString *)filterKey filterText:(NSString *)filterText {
    NSMutableArray *muArr = [NSMutableArray array];
    
    if (filterText != nil && filterText.length > 0 && filterKey.length != 0) {
        //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
        for (id model in dataArr) {
            NSString *tempStr = [model valueForKey:filterKey];
            
            // 把所有的搜索结果转成成 拼音 + 原生
            NSString *pinyin = [NSString xq_transformToSearchPinyin:tempStr];
            // 搜索是否包含
            if ([pinyin rangeOfString:filterText options:NSCaseInsensitiveSearch].length > 0) {
                [muArr addObject:model];
                continue;
            }
            
            
            // 模糊搜索
            BOOL isFind = [self xq_vagueFindWithContentText:tempStr filterText:filterText];
            if (isFind) {
                // 已经找到了
                [muArr addObject:model];
            }
            
        }
        
    }else {
        // 没有搜索字
    }
    return muArr;
}


/**
 模糊搜索
 */
+ (BOOL)xq_vagueFindWithContentText:(NSString *)contentText filterText:(NSString *)filterText {
    
    if (filterText.length > contentText.length) {
        // 超过长度, 没必要模糊搜索
        return NO;
    }else if (filterText.length == contentText.length) {
        // 相等只需要判断是否相等
        return [filterText isEqualToString:contentText];
    }
    
    NSUInteger lastLocation = 0;
    NSString *lastContentText = contentText;
    for (int i = 0; i < filterText.length; i++) {
        // 获取当前查找字符串
        NSString *str = [filterText substringWithRange:NSMakeRange(i, 1)];
        // 是否存在
        NSRange range = [lastContentText rangeOfString:str options:NSCaseInsensitiveSearch];
        if (range.length == 0) {
            // 条件不符合
            return NO;
        }
        
        // 记录这次的位置
        lastLocation = range.location + range.length;
        // 获取当前内容字符串
        lastContentText = [lastContentText substringWithRange:NSMakeRange(lastLocation, lastContentText.length - lastLocation)];
        
        if (i != filterText.length - 1) {
            // 还不是最后一个
            
            // 判断是否内容少于搜索内容了
            NSUInteger location = i + 1;
            NSUInteger length = filterText.length - location;
            if (lastContentText.length < length) {
                // 少于就没必要了再判断了
                return NO;
            }else if (lastContentText.length == length) {
                // 等于就直接判断相等就行了
                NSString *fText = [filterText substringWithRange:NSMakeRange(location, length)];
                return [lastContentText isEqualToString:fText];
            }
            
        }
        
    }
    
    return YES;
}

+ (NSString *)xq_transformToSearchPinyin:(NSString *)aString {
    // 是否包含中文
    if (![XQPredicate isContainChineseWithStr:aString]) {
        return aString;
    }
    
    // 这里是有问题的, 因为拿 , 和 # 作为分割符号, 那么意味着输入 # 或者 , 就会搜索全部.
    
    // 转拼音
    NSString *str = [self xq_transformToPinyin:aString];
    return [NSString stringWithFormat:@"%@#%@", [str stringByReplacingOccurrencesOfString:@" " withString:@""], aString];
    // 暂时不要后面这些拼接, 直接结果加原字符串就行了.
    
    
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++) {
        
        for(int i = 0; i < pinyinArray.count;i++) {
            
            if (i == count) {
                [allString appendString:@"#"];
                //区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];
    //拼音首字母
    for (NSString *s in pinyinArray) {
        if (s.length > 0) {
            [initialStr appendString:[s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@", initialStr];
    [allString appendFormat:@"#%@", aString];
    return allString;
}

+ (NSString *)xq_transformToPinyin:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics,NO);
    return str.copy;
}

@end
