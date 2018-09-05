//
//  XQIPAddress.m
//  TestSwiftJson
//
//  Created by WXQ on 2018/9/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQIPAddress.h"

#import <SystemConfiguration/CaptiveNetwork.h>// 获取wifi
// 获取当前相关ip网络的
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
    //#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation XQIPAddress

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

/**
 获取当前wifi信息
 */
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

@end
