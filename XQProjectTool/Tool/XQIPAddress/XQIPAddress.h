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

#if TARGET_OS_IPHONE
#import <CoreLocation/CoreLocation.h>

typedef void(^XQIPAddressCallback)(void);
typedef void(^XQIPAddressWiFiInfoCallback)(NSDictionary *_Nullable wifiInfo);
typedef void(^XQIPAddressLocationStatusCallback)(CLAuthorizationStatus status);


#endif

NS_ASSUME_NONNULL_BEGIN

@interface XQIPAddress : NSObject

/**
 获取所有相关IP信息
 */
+ (NSDictionary *_Nullable)getIPAddresses;

/**
 获取设备当前网络IP地址
 
 @return 返回ipv4地址
 */
+ (NSString *_Nullable)getIPv4Address;

#if TARGET_OS_IPHONE
/**
 获取当前wifi信息
 
 @note 12.0 后, 需要开权限:  Capabilities -> Access WiFi Information -> ON
 
 注意!!! 13.0 后, 获取 wifi 需要先开启定位, 不然会获取失败( 好像是说获取wifi信息能间接获取到位置信息 )
 #import <CoreLocation/CoreLocation.h>
 CLLocationManager *locationManager = [[CLLocationManager alloc] init];
 [locationManager requestWhenInUseAuthorization];
 
 info.plist 定位
 key: Privacy - Location When In Use Usage Description
 
 (__bridge NSString *)kCNNetworkInfoKeySSID: wifi名称key (@"SSID")
 
 @param callback 获取成功, nil 表示未连接 wifi
 @param locationDeniedCallback 定位权限被拒绝 13.0 后才会调用这个
 
 */
+ (void)getWIFIInfoWithCallback:(XQIPAddressWiFiInfoCallback)callback
         locationDeniedCallback:(XQIPAddressLocationStatusCallback)locationDeniedCallback;
//+ (NSDictionary *_Nullable)getWIFIInfo;

#endif

#if TARGET_OS_OSX
+ (CWInterface *_Nullable)getOSXWIFIInfo;
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
+ (NSDictionary *_Nullable)getWANIPAddress;

/**
 获取内网IP
 
 @return 其实就是ipv4/ipv6的地址, 一般国内都是ipv4
 */
+ (NSString *_Nullable)getInIPAddress;

/**
 检测WIFI开关

 @return YES已打开wifi, NO未打开
 */
+ (BOOL)isWiFiEnabled;

/**
 连接wifi
 
 @param ssid wifi名称
 @param passphrase wifi密码, 无密码wifi传 @"" or nil 都可以
 @param completionHandler 系统返回结果
 
 error自定义code
 - 99997: 版本不支持,  >= iOS11 才支持
 - 99996: 未打开wifi
 - 99998: 连接失败(密码错误 or ssid没有找到符合的)
 
 
 @note 需要开启权限
 获取WiFi: Capabilities -> Access WiFi Infomation
 配置WiFi: Capabilities -> Hotspot Configuration
 
 NEHotspotConfigurationError 错误
 
 */
+ (void)xq_connectWiFiWithSSID:(NSString *)ssid passphrase:(NSString *)passphrase isWEP:(BOOL)isWEP completionHandler:(void (^)(NSError * __nullable error))completionHandler;



@end

NS_ASSUME_NONNULL_END

