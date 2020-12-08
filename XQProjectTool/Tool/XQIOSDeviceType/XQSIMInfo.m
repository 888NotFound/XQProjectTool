//
//  XQSIMInfo.m
//  CMPageTitleView
//
//  Created by WXQ on 2019/8/1.
//

#import "XQSIMInfo.h"

#if TARGET_OS_IOS
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#endif

@implementation XQSIMInfo

#if TARGET_OS_IOS

// 获取运营商信息
+ (NSDictionary <NSString *, CTCarrier *> *)getCarrierInfo {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    if (@available(iOS 12.0, *)) {
        if (info.serviceSubscriberCellularProviders.allKeys.count > 0) {
            return info.serviceSubscriberCellularProviders;
        }
    }
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier) {
        return @{@"xq": carrier};
    }
    return nil;
//    carrier.carrierName 这个就是运营商名称
    

    
//    //NSLog(@"carrier = %@", carrier);
//    if (carrier == nil) {
//        if (callback) {
//            callback(@"", @"不能识别");
//        }
//        return;
//    }
//
//    NSString *code = [carrier mobileNetworkCode];
//    if (code == nil) {
//        if (callback) {
//            callback(@"", @"不能识别");
//        }
//        return;
//    }
//
//    NSString *description = @"不能识别";
//    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
//        description = @"移动运营商";
//    } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
//        description = @"联通运营商";
//    } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
//        description = @"电信运营商";
//    } else if ([code isEqualToString:@"20"]) {
//        description = @"铁通运营商";
//    }
//
//    if (callback) {
//        callback(code, description);
//    }
}

+ (nullable CTCarrier *)getFirstCarrierInfo {
    NSDictionary *dic = [self getCarrierInfo];
    if (dic && dic.allKeys.count > 0) {
        return dic[dic.allKeys.firstObject];
    }
    return nil;
}

#endif

@end
