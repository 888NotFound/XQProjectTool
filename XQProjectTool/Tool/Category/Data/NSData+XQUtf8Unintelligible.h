//
//  NSData+XQUtf8Unintelligible.h
//  XQFBaseUIOC
//
//  Created by WXQ on 2020/4/18.
//  Copyright © 2020 SyKing. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSData (XQUtf8Unintelligible)

/// 替换非utf8字符
/// 注意：如果是三字节utf-8，第二字节错误，则先替换第一字节内容(认为此字节误码为三字节utf8的头)，然后判断剩下的两个字节是否非法；
///
/// @note 原文链接 https://blog.csdn.net/cuibo1123/article/details/40938225  https://www.jianshu.com/p/1b3cbcbd7f66
///
/// @note 因为系统 [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] 检测 data 有非 utf-8 的字节, 那么就会直接返回 nil.  所以才衍生了这个方法
///
+ (NSData *)xq_replaceNoUtf8:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
