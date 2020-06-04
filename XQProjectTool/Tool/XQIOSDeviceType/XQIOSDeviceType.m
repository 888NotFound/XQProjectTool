//
//  XQIOSDeviceType.m
//  AFNetworking
//
//  Created by WXQ on 2019/1/8.
//

#import "XQIOSDeviceType.h"
#import <sys/utsname.h>



@implementation XQIOSDeviceType

static NSString *iPhoneType_ = @"";

#pragma mark -- 获取机型

+ (NSString *)getIPhoneType {
    if ([iPhoneType_ isEqualToString:@""] || !iPhoneType_) {
        iPhoneType_ = [self iPhoneType];
    }
    return iPhoneType_;
}


+ (XQIOSDevModel)getIOSDevType {
    NSString *str = [self getIPhoneType];
    XQIOSDevType type = XQIOSDevTypeUnknow;
    NSInteger subtype = 0;
    
    if ([str hasPrefix:@"iPhone"]) {
        type = XQIOSDevTypeIPhone;
        
        if ([str hasPrefix:@"iPhone 2G"]) {
            subtype = XQIPhoneDevType2G;
        }else if ([str hasPrefix:@"iPhone 3G"]) {
            subtype = XQIPhoneDevType3G;
        }else if ([str hasPrefix:@"iPhone 3GS"]) {
            subtype = XQIPhoneDevType3GS;
        }else if ([str isEqualToString:@"iPhone 4"]) {
            subtype = XQIPhoneDevType4;
        }else if ([str hasPrefix:@"iPhone 4S"]) {
            subtype = XQIPhoneDevType4S;
        }else if ([str isEqualToString:@"iPhone 5"]) {
            subtype = XQIPhoneDevType5;
        }else if ([str hasPrefix:@"iPhone 5C"]) {
            subtype = XQIPhoneDevType5C;
        }else if ([str hasPrefix:@"iPhone 5S"]) {
            subtype = XQIPhoneDevType5S;
        }else if ([str hasPrefix:@"iPhone 6 Plus"]) {
            subtype = XQIPhoneDevType6Plus;
        }else if ([str hasPrefix:@"iPhone 6"]) {
            subtype = XQIPhoneDevType6;
        }else if ([str hasPrefix:@"iPhone 6S"]) {
            subtype = XQIPhoneDevType6S;
        }else if ([str hasPrefix:@"iPhone 6S Plus"]) {
            subtype = XQIPhoneDevType6SPlus;
        }else if ([str hasPrefix:@"iPhone SE"]) {
            subtype = XQIPhoneDevTypeSE;
        }else if ([str isEqualToString:@"iPhone 7"]) {
            subtype = XQIPhoneDevType7;
        }else if ([str hasPrefix:@"iPhone 7 Plus"]) {
            subtype = XQIPhoneDevType7Plus;
        }else if ([str isEqualToString:@"iPhone 8"]) {
            subtype = XQIPhoneDevType8;
        }else if ([str hasPrefix:@"iPhone 8 Plus"]) {
            subtype = XQIPhoneDevType8Plus;
        }else if ([str hasPrefix:@"iPhone X"]) {
            subtype = XQIPhoneDevTypeX;
        }else if ([str isEqualToString:@"iPhone XS"]) {
            subtype = XQIPhoneDevTypeXS;
        }else if ([str isEqualToString:@"iPhone XS Max"]) {
            subtype = XQIPhoneDevTypeXSMax;
        }else if ([str isEqualToString:@"iPhone XR"]) {
            subtype = XQIPhoneDevTypeXR;
        }
        
    }else if ([str hasPrefix:@"iPod"]) {
        type = XQIOSDevTypeIPod;
        
        if ([str hasPrefix:@"iPhone Touch 1G"]) {
            subtype = XQIPodDevTypeTouch1G;
        }else if ([str hasPrefix:@"iPhone Touch 2G"]) {
            subtype = XQIPodDevTypeTouch2G;
        }else if ([str hasPrefix:@"iPhone Touch 3G"]) {
            subtype = XQIPodDevTypeTouch3G;
        }else if ([str isEqualToString:@"iPhone Touch 4G"]) {
            subtype = XQIPodDevTypeTouch4G;
        }else if ([str hasPrefix:@"iPhone Touch 5G"]) {
            subtype = XQIPodDevTypeTouch5G;
        }
        
    }else if ([str hasPrefix:@"iPad"]) {
        type = XQIOSDevTypeIPod;
        
        if ([str hasPrefix:@"iPad 1G"]) {
            subtype = XQIPadDevType1G;
        }else if ([str hasPrefix:@"iPad 3G"]) {
            subtype = XQIPadDevType3G;
        }else if ([str hasPrefix:@"iPad 2"]) {
            subtype = XQIPadDevType2;
        }else if ([str hasPrefix:@"iPad Mini 1G"]) {
            subtype = XQIPadDevTypeMini1G;
        }else if ([str hasPrefix:@"iPad Mini 2G"]) {
            subtype = XQIPadDevTypeMini2G;
        }else if ([str hasPrefix:@"iPad 3"]) {
            subtype = XQIPadDevType3;
        }else if ([str hasPrefix:@"iPad 4"]) {
            subtype = XQIPadDevType4;
        }else if ([str hasPrefix:@"iPad Air"]) {
            subtype = XQIPadDevTypeAir;
        }else if ([str hasPrefix:@"iPad Air 2"]) {
            subtype = XQIPadDevTypeAir2;
        }else if ([str hasPrefix:@"iPad Pro 9.7"]) {
            subtype = XQIPadDevTypePro97;
        }else if ([str hasPrefix:@"iPad Pro 12.9"]) {
            subtype = XQIPadDevTypePro129;
        }
        
    }else if ([str hasPrefix:@"Apple TV"]) {
        type = XQIOSDevTypeAppleTV;
        
        if ([str hasPrefix:@"Apple TV 2"]) {
            subtype = XQAppleTVDevType2;
        }else if ([str hasPrefix:@"Apple TV 3"]) {
            subtype = XQAppleTVDevType3;
        }else if ([str hasPrefix:@"Apple TV 4"]) {
            subtype = XQAppleTVDevType4;
        }
        
    }else if ([str hasPrefix:@"iPhone Simulator"]) {
        type = XQIOSDevTypeSimulator;
        
        if ([str hasPrefix:@"iPhone Simulator(i386)"]) {
            subtype = XQIPhoneSimulatorDevTypeI386;
        }else if ([str hasPrefix:@"iPhone Simulator(x86_64)"]) {
            subtype = XQIPhoneSimulatorDevTypeX86_64;
        }
        
    }
    
    XQIOSDevModel model = {type, subtype, subtype, subtype, subtype, subtype};
    
    return model;
}

+ (NSString *)iPhoneType {
    //需要导入头文件：#import <sys/utsname.h>
    
#if TARGET_OS_IPHONE
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
#pragma mark - iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"] || [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"] || [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"] || [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    
    
#pragma mark - iPod
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
#pragma mark - iPad
    // ipad1
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    // ipad2
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2(WIFI)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2(CMMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G(WIFI)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G(GSM+CDMA)";
    
    // ipad3
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3(WIFI)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3(GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4(WIFI)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4(GSM+CDMA)";
    
    //ipad4
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air(WIFI)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air(Cellular)";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G(WIFI)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G(Cellular)";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    //ipad5
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4(WIFI)";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4(LTE)";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    //ipad6
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
#pragma mark - Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4";
    
#pragma mark - iPhone Simulator
    // 手机模拟器
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator(i386)";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator(x86_64)";
    
    return platform;
    
#else
    // mac
    NSString *result = @"Unknown Mac";
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    if (len) {
        NSMutableData *data = [NSMutableData dataWithLength:len];
        sysctlbyname("hw.model", [data mutableBytes], &len, NULL, 0);
        result = [NSString stringWithUTF8String:[data bytes]];
    }
    
    return result;
    
#endif
}




@end
