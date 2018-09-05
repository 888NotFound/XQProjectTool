//
//  XQIPAddress.h
//  TestSwiftJson
//
//  Created by WXQ on 2018/9/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQIPAddress : NSObject

/**
 获取所有相关IP信息
 */
+ (NSDictionary *)getIPAddresses;

/**
 获取设备当前网络IP地址
 
 @return 返回ipv4地址
 */
+ (NSString *)getIPv4Address;

/**
 获取当前wifi信息
 
 @return nil表示获取不到, 就可能当前不是在wifi环境下
 */
+ (NSDictionary *)getWIFIInfo;

/**
 是否打开热点
 
 @return YES打开
 */
+ (BOOL)flagWithOpenHotSpot;

@end
