//
//  XQKeychain.h
//  XQKeychain
//
//  Created by SyKingW on 2018/1/6.
//  Copyright © 2018年 SyKingW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQKeychain : NSObject

#pragma mark -- Key
/**
 根据现在只是用这个保存当作设备唯一标识符, 直接调用这个方法就好了, 下面的保存基本不用调用了, 在方法里面, 已经直接判断是否存在uuid了, 如不存在, 则会创建一个保存
 */
+ (void)initUDID;

/**
 获取uuid
 */
+ (NSString *)getUUIDStr;

/**
 删除uuid, 删除之后, 需要重新调用initUDID, 不然一直获取都是nil
 */
+ (int)deleteUUIDStr;

#pragma mark -- 账号密码

/**
 保存账号密码

 @param acc 账号
 @param pwd 密码
 */
+ (int)savePwdWithAcc:(NSString *)acc pwd:(NSString *)pwd;

/**
 获取某个账号密码
 */
+ (NSString *)getPwdWithAcc:(NSString *)acc;

/**
 获取所有账号
 */
+ (NSArray *)getAllAcc;

/**
 获取所有账号信息(含有密码)
 */
+ (NSArray *)getAllAccInfo;

/**
 删除某个账号信息
 */
+ (int)deleteAcc:(NSString *)acc;

/**
 删除所有账号信息
 */
+ (int)deleteAllAcc;

@end














