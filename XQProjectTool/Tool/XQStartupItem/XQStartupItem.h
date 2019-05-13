//
//  XQStartupItem.h
//
//  Created by WXQ on 2019/5/10.
//  Copyright © 2019 WXQ. All rights reserved.
//

/**
 参考了美团 https://tech.meituan.com/2018/12/06/waimai-ios-optimizing-startup.html 和 https://github.com/RamboQiu/RAMUtil
 
 现在还有一个问题, 这样创建了一个静态的 struct 并且里面有一个 block, 但是启动项就是只需要一次, 是否要去消除他? 怎么消除?
 */

#import <Foundation/Foundation.h>

#pragma mark - 实现存储block

typedef struct {
    char * _Nullable key;
    __unsafe_unretained void (^ _Nullable block)(void);
}XQ_SI_Model;

// key最多16位
#define __XQ_SI_Key_A "_XQ_SI_Key_A"
#define __XQ_SI_Key_B "_XQ_SI_Key_B"

// 节点name
#define __XQ_SI_Sectname "__XQBlock"

/**
 注册启动项目
 
 @param key 传上面的 __XQ_SI_Key_A 这些, 或者自己自定义一个 #define 字符串
 @param block 传入执行的 block ( XQ_SI_Model 的 block ) 
 
 @note used 表示一定会使用该函数, 保证 release 也不会被优化掉
 
 使用示例
 XQ_SI_Register(__XQ_SI_Key_A, ^(void) {
    // 执行启动代码
    // 目前还有一个问题, 就是不会自动释放block, 需要自己手动在这里去释放block  __xq__XQ_SI_Key_A.block = nil;
 })
 
 */
#define XQ_SI_Register(key, block) __attribute__((used, section(__XQ_SI_Sectname "," key))) \
static XQ_SI_Model __xq##key = (XQ_SI_Model){((char *)&#key), block};




/**
 执行启动项目

 @param key 相对于项目的key
 
 @return 0 成功, 1 key为空了, 2 找不到对于key的信息
 */
extern int xq_execute_SI(const char * _Nullable key);

NS_ASSUME_NONNULL_BEGIN

@interface XQStartupItem : NSObject

/**
 执行启动项目
 
 @param key 相对于项目的key
 */
+ (void)executeWithKey:(NSString *)key;

/**
 执行启动项目A
 */
+ (void)executeA;

/**
 执行启动项目B
 */
+ (void)executeB;

@end

NS_ASSUME_NONNULL_END
