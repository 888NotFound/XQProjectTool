//
//  XQIPAddress.h
//  TestSwiftJson
//
//  Created by WXQ on 2018/9/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <CoreWLAN/CoreWLAN.h>
#endif

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

#if TARGET_OS_IPHONE
/**
 获取当前wifi信息
 iOS12获取不到问题: Capabilities -> Access WiFi Information -> ON
 
 @return nil表示获取不到, 就可能当前不是在wifi环境下
 */
+ (NSDictionary *)getWIFIInfo;
#endif

#if TARGET_OS_OSX
+ (CWInterface *)getOSXWIFIInfo;
#endif


/**
 是否打开热点
 
 @return YES打开
 */
+ (BOOL)flagWithOpenHotSpot;

/**
 获取外网ip
 
 @return dic[@"cip"] 则是外网ip了
 */
+ (NSDictionary *)getWANIPAddress;

/**
 获取内网IP
 
 @return 其实就是ipv4/ipv6的地址, 一般国内都是ipv4
 */
+ (NSString *)getInIPAddress;

@end

