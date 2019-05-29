//
//  XQXMLParser.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//


/*
 参考: https://www.jianshu.com/p/73acb89d816f
 在此基础做了一些完善和修改
 */

#import <Foundation/Foundation.h>

enum {
    XQXMLParserOptionsProcessNamespaces           = 1 << 0, // 指定接收器呈现命名空间和指定的标签名称
    XQXMLParserOptionsReportNamespacePrefixes     = 1 << 1, // 指定接收器呈现命名空间的范围
    XQXMLParserOptionsResolveExternalEntities     = 1 << 2, // 指定接收器呈现外部实体的声明
};

typedef NSUInteger XQXMLParserOptions;


NS_ASSUME_NONNULL_BEGIN

@interface XQXMLParser : NSObject

/**
 NSData格式的XML转换成字典
 
 @param data NSData格式的XML
 @param error 错误码
 @return 字典
 */
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)error;

/**
 NSString格式的XML转换成字典
 
 @param string NSString格式的XML
 @param error 错误码
 @return 字典
 */
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)error;

/**
 NSData格式的XML按照指定的形式转换成字典
 
 @param data NSData格式的XML
 @param options 指定的形式
 @param error 错误码
 @return 字典
 */
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XQXMLParserOptions)options error:(NSError *)error;

/**
 NSString格式的XML按照指定的形式转换成字典
 
 @param string NSString格式的XML
 @param options 指定的形式
 @param error 错误码
 @return 字典
 */
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XQXMLParserOptions)options error:(NSError *)error;
/**
 NSData格式的XML转换成JSON字符串
 
 @param data NSData格式的XML
 @param error 错误码
 @return JSON字符串
 */

+ (NSString *)jsonStringForXMLData:(NSData *)data error:(NSError *)error;

/**
 NSString格式的XML转换成JSON字符串
 
 @param string NSString格式的XML
 @param error 错误码
 @return JSON字符串
 */
+ (NSString *)jsonStringForXMLString:(NSString *)string error:(NSError *)error;

/**
 NSData格式的XML按照指定的形式转换成JSON字符串
 
 @param data NSData格式的XML
 @param options 指定的形式
 @param error 错误码
 @return JSON字符串
 */
+ (NSString *)jsonStringForXMLData:(NSData *)data options:(XQXMLParserOptions)options error:(NSError *)error;

/**
 NSString格式的XML按照指定的形式转换成JSON字符串
 
 @param string NSString格式的XML
 @param options 指定的形式
 @param error 错误码
 @return JSON字符串
 */
+ (NSString *)jsonStringForXMLString:(NSString *)string options:(XQXMLParserOptions)options error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
