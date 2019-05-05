//
//  XQRuntimeModel.h
//  FMDB
//
//  Created by WXQ on 2019/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQRuntimeModel : NSObject

/** 属性名 */
@property (nonatomic, copy) NSString *xq_name;
/** 属性名类型
 
 - "NSString": 字符串 ( 是 OC对象, xq_encoding 都是类名 )
 - "q" "i" "s" "l" "S" "L" "Q": 整形
 - "f" "d": 浮点型
 - "B": 二进制
 
 这些具体可上官方查阅
 
 */
@property (nonatomic, copy) NSString *xq_encoding;
/** 当前值 */
@property (nonatomic, copy) id xq_value;

@end

NS_ASSUME_NONNULL_END
