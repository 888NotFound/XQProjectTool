//
//  NSObject+ArchiverData.h
//  Runtime
//
//  Created by ladystyle100 on 2017/6/9.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 遵守NSCoding, 如没有什么特别需要改的属性, 自己手动写入的, 可以直接在.m 调用该宏就行 */
#define XQArchiverM - (instancetype)initWithCoder:(NSCoder *)aDecoder {\
self = [super init];\
if (self) {\
[self decoder:aDecoder];\
}\
return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder {\
[self encoder:aCoder];\
}

@interface NSObject (XQArchiverData)

/** 解档 */
- (void)decoder:(NSCoder *)coder;
/** 归档 */
- (void)encoder:(NSCoder *)coder;

@end
