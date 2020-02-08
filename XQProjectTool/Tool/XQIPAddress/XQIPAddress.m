//
//  XQIPAddress.m
//  TestSwiftJson
//
//  Created by WXQ on 2018/9/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQIPAddress.h"

#if TARGET_OS_IPHONE

#import <SystemConfiguration/CaptiveNetwork.h>// 获取wifi
#import <NetworkExtension/NEHotspotConfigurationManager.h>

#endif

// 获取当前相关ip网络的
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
    //#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


#if TARGET_OS_IPHONE

@interface XQIPAddress () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) XQIPAddressWiFiInfoCallback wifiInfoCallback;
@property (nonatomic, copy) XQIPAddressLocationStatusCallback locationStatusCallback;


@end

#elseif

@interface XQIPAddress ()

@end

#endif



@implementation XQIPAddress

+ (instancetype)manager {
    static XQIPAddress *address = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        address = [XQIPAddress new];
    });
    
    return address;
}

/**
 获取所有相关IP信息
 
 @return 如下
 4G网络
 {
 "awdl0/ipv6" = "fe80::94fe:9ff:fefc:19ac";
 "en2/ipv4" = "169.254.246.244";
 "en2/ipv6" = "fe80::8bb:72cc:4100:93e";
 "ipsec0/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "ipsec1/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "lo0/ipv4" = "127.0.0.1";
 "lo0/ipv6" = "fe80::1";
 "pdp_ip0/ipv4" = "10.229.245.134";
 "pdp_ip1/ipv6" = "2409:8809:8e92:ee8c:1912:b14a:b3d:a2a3";
 "utun0/ipv6" = "fe80::b4af:f723:1cf6:e266";
 "utun1/ipv6" = "fe80::408a:5941:f270:72b";
 }
 
 WIFI
 {
 "awdl0/ipv6" = "fe80::94fe:9ff:fefc:19ac";
 "en0/ipv4" = "192.168.0.103";
 "en0/ipv6" = "fe80::14ff:58bc:2c6a:8951";
 "en2/ipv4" = "169.254.246.244";
 "en2/ipv6" = "fe80::8bb:72cc:4100:93e";
 "ipsec0/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "ipsec1/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "lo0/ipv4" = "127.0.0.1";
 "lo0/ipv6" = "fe80::1";
 "pdp_ip1/ipv6" = "2409:8809:8e92:ee8c:1912:b14a:b3d:a2a3";
 "utun0/ipv6" = "fe80::b4af:f723:1cf6:e266";
 "utun1/ipv6" = "fe80::408a:5941:f270:72b";
 }
 
 无网络
 {
 "awdl0/ipv6" = "fe80::94fe:9ff:fefc:19ac";
 "en2/ipv4" = "169.254.246.244";
 "en2/ipv6" = "fe80::8bb:72cc:4100:93e";
 "ipsec0/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "ipsec1/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "lo0/ipv4" = "127.0.0.1";
 "lo0/ipv6" = "fe80::1";
 "pdp_ip1/ipv6" = "2409:8809:8e92:ee8c:1912:b14a:b3d:a2a3";
 "utun0/ipv6" = "fe80::b4af:f723:1cf6:e266";
 "utun1/ipv6" = "fe80::408a:5941:f270:72b";
 }
 
 这个是开启热点情况下, 有bridge
 {
 "bridge100/ipv4" = "172.20.10.1";
 "bridge100/ipv6" = "fe80::862:dd35:f20b:77e7";
 "ipsec0/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "ipsec1/ipv6" = "2409:8809:8e92:ee8c:18f3:5fd1:38b0:4054";
 "lo0/ipv4" = "127.0.0.1";
 "lo0/ipv6" = "fe80::1";
 "pdp_ip0/ipv4" = "10.229.245.134";
 "pdp_ip1/ipv6" = "2409:8809:8e92:ee8c:1912:b14a:b3d:a2a3";
 "utun0/ipv6" = "fe80::b4af:f723:1cf6:e266";
 "utun1/ipv6" = "fe80::408a:5941:f270:72b";
 }
 
 */
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
        // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
            // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                }else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
            // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/**
 获取设备当前网络IP地址
 
 @return 返回ipv4地址
 */
+ (NSString *)getIPv4Address {
    NSArray *searchArray = 1 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/
      IOS_WIFI @"/" IP_ADDR_IPv4,
      IOS_WIFI @"/" IP_ADDR_IPv6,
      IOS_CELLULAR @"/" IP_ADDR_IPv4,
      IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/
      IOS_WIFI @"/" IP_ADDR_IPv6,
      IOS_WIFI @"/" IP_ADDR_IPv4,
      IOS_CELLULAR @"/" IP_ADDR_IPv6,
      IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    // xq_这里有个问题...因为一直是没有 pdp_ip1/ipv6 这个key的, 只有 pdp_ip0/ipv6 . 那么无论传yes or no, 都是ipv4
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if (address) {
            *stop = YES;
        }
    }];
    
    return address ? address : @"0.0.0.0";
}

#if TARGET_OS_IPHONE

/**
 获取当前wifi信息
 */
+ (void)getWIFIInfoWithCallback:(XQIPAddressWiFiInfoCallback)callback
         locationDeniedCallback:(XQIPAddressLocationStatusCallback)locationDeniedCallback {
    
    if (@available(iOS 13.0, *)) {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        // 如果是iOS13 未开启地理位置权限 需要提示一下
        if (status == kCLAuthorizationStatusNotDetermined) {
            // 未选择
            [XQIPAddress manager].wifiInfoCallback = callback;
            [XQIPAddress manager].locationStatusCallback = locationDeniedCallback;
            
            if (![XQIPAddress manager].locationManager) {
                [XQIPAddress manager].locationManager = [[CLLocationManager alloc] init];
                [XQIPAddress manager].locationManager.delegate = [XQIPAddress manager];
            }
            
            NSLog(@"请求定位权限");
            [[XQIPAddress manager].locationManager requestWhenInUseAuthorization];
            
        }else if (status == kCLAuthorizationStatusRestricted ||
                  status == kCLAuthorizationStatusDenied) {
            NSLog(@"被拒绝定位");
            if (locationDeniedCallback) {
                locationDeniedCallback(status);
            }
            
        }else {
            // 已同意
            NSLog(@"已同意定位权限");
            if (callback) {
                NSDictionary *info = [self getWIFIInfo];
                callback(info);
            }
            
        }
        
    }else {
        
        if (callback) {
            NSDictionary *info = [self getWIFIInfo];
            callback(info);
        }
        
    }
    
}

+ (NSDictionary *)getWIFIInfo {
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        CFStringRef strRef = (__bridge CFStringRef)ifnam;
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo(strRef);
        CFRelease(strRef);
    }
    
    return info;
}

#endif

#if TARGET_OS_OSX
+ (CWInterface *)getOSXWIFIInfo {
    CWInterface * interface = [[CWWiFiClient sharedWiFiClient] interface];
    return interface;
}
#endif


/**
 判断热点是否开启
 */
+ (BOOL)flagWithOpenHotSpot {
    NSDictionary *dict = [self getIPAddresses];
    if ( dict ) {
        NSArray *keys = dict.allKeys;
        for ( NSString *key in keys) {
            if ( key && [key containsString:@"bridge"])
                return YES;
        }
    }
    return NO;
}


/**
 获取外网ip
 */
+ (NSDictionary *)getWANIPAddress  {
    NSError *error;
    
    /*
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
        //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
            //对字符串进行处理，然后进行json解析
            //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp = [ip substringToIndex:ip.length-1];
            //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict;
    }
     */
    
    // 这个信息获取的比较完全
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    if (!error && ip) {
        NSData *data = [ip dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error && [dic isKindOfClass:[NSDictionary class]]) {
            return dic;
        }
    }
    
    return @{};
}

/**
 获取内网IP
 */
+ (NSString *)getInIPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
        // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
            // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
        // 释放内存
    freeifaddrs(interfaces);
    return address;
}


// 检测WIFI开关
+ (BOOL)isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}


/**
 连接wifi
 @note 需要开启权限
 获取WiFi: Capabilities -> Access WiFi Infomation
 配置WiFi: Capabilities -> Hotspot Configuration

 @param ssid wifi名称
 @param passphrase wifi密码
 
 
 - -1: 版本不支持
 - 0: 未打开wifi
 - 1: 正常
 
 */
+ (void)xq_connectWiFiWithSSID:(NSString *)ssid passphrase:(NSString *)passphrase isWEP:(BOOL)isWEP completionHandler:(void (^)(NSError * __nullable error))completionHandler {
#if TARGET_OS_IPHONE
    if ([XQIPAddress isWiFiEnabled]) {
        if (@available(iOS 11.0, *)) {
            
            NEHotspotConfiguration *configuration = nil;
            if (passphrase.length == 0) {
                // 没有密码
                configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid];
            }else {
                configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:passphrase isWEP:isWEP];
            }
            
            // 只加入一次..
            configuration.joinOnce = YES;
            
            [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
                
                if (error) {
                    if (completionHandler) {
                        completionHandler(error);
                    }
                    
                }else {
                    
                    // 延时是因为偶尔系统是已经连接, 但是这边还没可以获取到wifi那么快. 一般第一次进来app控制就特别明显
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        /**
                         这里要注意
                         当 ssid 错误时 和 当 密码 错误时, 系统照样回你成功...所以要在这里获取一下当前wifi名称, 来判断是否连接成功
                         密码错误连接大约要 20 秒.
                         */
                        NSDictionary *dic = [XQIPAddress getWIFIInfo];
                        if (dic && dic[@"SSID"]) {
                            
                            NSString *c_ssid = dic[@"SSID"];
                            if ([c_ssid isEqualToString:ssid]) {
                                if (completionHandler) {
                                    completionHandler(nil);
                                }
                            }else {
                                NSError *xq_error = [NSError errorWithDomain:@"未连接wifi" code:99998 userInfo:nil];
                                if (completionHandler) {
                                    completionHandler(xq_error);
                                }
                            }
                            
                        }else {
                            
                            NSError *xq_error = [NSError errorWithDomain:@"未连接wifi" code:99998 userInfo:nil];
                            if (completionHandler) {
                                completionHandler(xq_error);
                            }
                        }
                        
                    });
                    
                    
                }
                
            }];
            
            return;
            
        } else {
            NSError *xq_error = [NSError errorWithDomain:@"自定义错误,版本过低" code:99997 userInfo:nil];
            if (completionHandler) {
                completionHandler(xq_error);
            }
            return;
        }
        
    }
    
    NSError *xq_error = [NSError errorWithDomain:@"未打开wifi" code:99996 userInfo:nil];
    if (completionHandler) {
        completionHandler(xq_error);
    }
#endif
    
}


#if TARGET_OS_IPHONE

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        // 不管
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (self.wifiInfoCallback) {
            NSDictionary *info = [XQIPAddress getWIFIInfo];
            self.wifiInfoCallback(info);
        }
    }else {
        if (self.locationStatusCallback) {
            self.locationStatusCallback(status);
        }
    }
    
    // 释放掉
    self.wifiInfoCallback = nil;
    self.locationStatusCallback = nil;
    self.locationManager = nil;
    
    
}

#endif

@end




