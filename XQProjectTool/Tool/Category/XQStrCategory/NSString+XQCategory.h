//
//  NSString+XQCategory.h
//  Pods-XQTestEqual
//
//  Created by WXQ on 2019/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XQCategory)

/**
 字符串转为拼音

 @param aString 中文字符串
 @return 转为拼音后的字符串
 */
+ (NSString *)xq_transformToPinyin:(NSString *)aString;

/**
 字符串转为搜索拼音

 @return 返回结果
 - 无中文: 返回原字符串
 - 有文字
 */
+ (NSString *)xq_transformToSearchPinyin:(NSString *)aString;

/**
 根据字符串过滤数据

 @param dataArr 数据(字典, 或者model)
 @param filterKey 过滤字段
 @param filterText 过滤字符
 @return 过滤的结果
 */
+ (NSArray *)xq_filterDataWithDataArr:(NSArray *)dataArr filterKey:(NSString *)filterKey filterText:(NSString * _Nullable )filterText;

/**
 模糊搜索
 
 @param contentText 内容字符串
 @param filterText 搜索字符串
 @return 如下
 
 - NO: 不符合
 - YES: 符合
 
 @note 举个例子:
 contentText: "123哈jke"
 filterText: "2哈e"
 结果是YES
 
 contentText: "123哈jke"
 filterText: "j哈e"
 结果是NO
 
 就是会判断搜索字符串是否有按顺序的在内容字符串中, 有的话, 就返回正确
 
 
 */
+ (BOOL)xq_vagueFindWithContentText:(NSString *)contentText filterText:(NSString *)filterText;

@end

NS_ASSUME_NONNULL_END
