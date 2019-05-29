//
//  XQXMLParser.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/28.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQXMLParser.h"

NSString *const kXQXMLParserNodeKey = @"nodeValue";

@interface XQXMLParser() <NSXMLParserDelegate>

//字典堆栈数组
@property (nonatomic, strong) NSMutableArray *dictionaryStack;
//文本
@property (nonatomic, strong) NSMutableString *textInProgress;
//错误
@property (nonatomic, strong) NSError *errorPointer;

@end

@implementation XQXMLParser

#pragma mark - Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)error
{
    XQXMLParser *xmlParser = [[XQXMLParser alloc]initWithError:error];
    NSDictionary *rootDictionary = [xmlParser objectWithData:data options:0];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XQXMLParser dictionaryForXMLData:data error:error];
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XQXMLParserOptions)options error:(NSError *)error
{
    XQXMLParser *xmlParser = [[XQXMLParser alloc]initWithError:error];
    NSDictionary *rootDictionary = [xmlParser objectWithData:data options:options];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XQXMLParserOptions)options error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XQXMLParser dictionaryForXMLData:data options:options error:error];
}

+ (NSString *)jsonStringForXMLData:(NSData *)data error:(NSError *)error
{
    NSDictionary *dic = [XQXMLParser dictionaryForXMLData:data error:error];
    return [self dictionaryTransformedIntoJSONWithDictionary:[dic mutableCopy]];
}

+ (NSString *)jsonStringForXMLString:(NSString *)string error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XQXMLParser jsonStringForXMLData:data error:error];
}

+ (NSString *)jsonStringForXMLData:(NSData *)data options:(XQXMLParserOptions)options error:(NSError *)error
{
    NSDictionary *dic = [XQXMLParser dictionaryForXMLData:data options:options error:error];
    return [self dictionaryTransformedIntoJSONWithDictionary:[dic mutableCopy]];
}

+ (NSString *)jsonStringForXMLString:(NSString *)string options:(XQXMLParserOptions)options error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XQXMLParser jsonStringForXMLData:data options:options error:error];
}
#pragma mark 字典转JSON方法
+ (NSString *)dictionaryTransformedIntoJSONWithDictionary:(NSMutableDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
#pragma mark - 解析
/**
 初始化
 @param error 错误制作
 @return self
 */
- (instancetype)initWithError:(NSError *)error
{
    if (self == [super init]) {
        self.errorPointer = error;
    }
    return self;
}
/**
 解析成字典
 @param data 数据
 @param options 类型
 @return 字典
 */
- (NSDictionary *)objectWithData:(NSData *)data options:(XQXMLParserOptions)options
{
    //    每次处理前先重新初始化
    self.dictionaryStack = [NSMutableArray array];
    self.textInProgress = [NSMutableString string];
    //    用新字典初始化堆栈
    [self.dictionaryStack addObject:[NSMutableDictionary dictionary]];
    //    解析XML
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    //    解析类型
    [parser setShouldProcessNamespaces:(options & XQXMLParserOptionsProcessNamespaces)];
    [parser setShouldReportNamespacePrefixes:(options & XQXMLParserOptionsReportNamespacePrefixes)];
    [parser setShouldResolveExternalEntities:(options & XQXMLParserOptionsResolveExternalEntities)];
    //    绑定代理
    parser.delegate = self;
    //    开始解析
    BOOL isSuccess = [parser parse];
    //    判断是否成功
    if (isSuccess) {
        NSDictionary *resultDict = [self.dictionaryStack firstObject];
        return resultDict;
    }
    return nil;
}

#pragma mark -  NSXMLParserDelegate methods
//文档开始读取
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}
//解析标签开始
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    //    获取当前字典
    NSMutableDictionary *parentDict = [self.dictionaryStack lastObject];
    //    创建子字典
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    //    拼接字典
    [childDict addEntriesFromDictionary:attributeDict];
    //    判断存不存在键值对
    id existingValue = [parentDict objectForKey:elementName];
    //    存在说明该键值对为数组
    if (existingValue) {
        NSMutableArray *array = nil;
        //        判断该键值对的数组是否存在
        if ([existingValue isKindOfClass:[NSMutableArray class]]) {
            array = (NSMutableArray *)existingValue;
        }else
        {
            array = [NSMutableArray array];
            [array addObject:existingValue];
            //            用新的数组替换旧的
            [parentDict setObject:array forKey:elementName];
        }
        //        数组中添加新的子字典
        [array addObject:childDict];
    }else
    {
        //        不存在说明只是普通的键值对
        [parentDict setObject:childDict forKey:elementName];
    }
    //    更新堆栈数组
    [self.dictionaryStack addObject:childDict];
}
//获取标签对应的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.textInProgress appendString:string];
}
//解析标签结束
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableDictionary *dictInProgress = [self.dictionaryStack lastObject];
    if (self.textInProgress.length > 0) {
        NSString *trmmedString = [self.textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [dictInProgress setObject:[trmmedString mutableCopy] forKey:kXQXMLParserNodeKey];
        
        self.textInProgress = [NSMutableString string];
    }
    [self.dictionaryStack removeLastObject];
}
//文档结束读取
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}
//遇到错误时停止解析
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.errorPointer = parseError;
}

@end
