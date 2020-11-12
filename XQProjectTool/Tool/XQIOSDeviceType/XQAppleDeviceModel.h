//
//  XQAppleDeviceModel.h
//  XQProjectTool
//
//  Created by WXQ on 2020/11/12.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XQAppleDevType) {
    XQAppleDevTypeUnknow = 0,
    XQAppleDevTypeIPhone,
    XQAppleDevTypeMac,
    XQAppleDevTypeIPod,
    XQAppleDevTypeIPad,
    XQAppleDevTypeAppleTV,
    XQAppleDevTypeAirPods,
    XQAppleDevTypeHomePod,
    XQAppleDevTypeSimulator,// 手机模拟器
};

// iphone
typedef NS_ENUM(NSInteger, XQIPhoneDevType) {
    XQIPhoneDevTypeUnknow = 0,
    XQIPhoneDevType2G,
    XQIPhoneDevType3G,
    XQIPhoneDevType3GS,
    XQIPhoneDevType4,
    XQIPhoneDevType4S,
    XQIPhoneDevType5,
    XQIPhoneDevType5C,
    XQIPhoneDevType5S,
    XQIPhoneDevType6,
    XQIPhoneDevType6Plus,
    XQIPhoneDevType6S,
    XQIPhoneDevType6SPlus,
    XQIPhoneDevTypeSE,
    // 因为还是小屏，就放在这
    XQIPhoneDevTypeSE2,
    XQIPhoneDevType7,
    XQIPhoneDevType7Plus,
    XQIPhoneDevType8,
    XQIPhoneDevType8Plus,
    XQIPhoneDevTypeX,
    XQIPhoneDevTypeXS,
    XQIPhoneDevTypeXSMax,
    XQIPhoneDevTypeXR,
    XQIPhoneDevType11,
    XQIPhoneDevType11Pro,
    XQIPhoneDevType11ProMax,
    XQIPhoneDevType12Mini,
    XQIPhoneDevType12,
    XQIPhoneDevType12Pro,
    XQIPhoneDevType12ProMax,
};

// ipod
typedef NS_ENUM(NSInteger, XQIPodDevType) {
    XQIPodDevTypeUnknow = 0,
    XQIPodDevTypeTouch1G,
    XQIPodDevTypeTouch2G,
    XQIPodDevTypeTouch3G,
    XQIPodDevTypeTouch4G,
    XQIPodDevTypeTouch5G,
};

// ipad
typedef NS_ENUM(NSInteger, XQIPadDevType) {
    XQIPadDevTypeUnknow = 0,
    XQIPadDevType1G,
    XQIPadDevType3G,
    
    XQIPadDevType2,
    XQIPadDevType3,
    XQIPadDevType4,
    
    XQIPadDevTypeMini1G,
    XQIPadDevTypeMini2G,
    XQIPadDevTypeMini3,
    XQIPadDevTypeMini4,
    
    XQIPadDevTypeAir,
    XQIPadDevTypeAir2,
    
    XQIPadDevTypePro97,
    XQIPadDevTypePro129,
    
};

// apple tv
typedef NS_ENUM(NSInteger, XQAppleTVDevType) {
    XQAppleTVDevTypeUnknow = 0,
    XQAppleTVDevType2,
    XQAppleTVDevType3,
    XQAppleTVDevType4,
};

// 手机模拟器
typedef NS_ENUM(NSInteger, XQIPhoneSimulatorDevType) {
    XQIPhoneSimulatorDevTypeUnknow = 0,
    XQIPhoneSimulatorDevTypeI386,
    XQIPhoneSimulatorDevTypeX86_64,
};

NS_ASSUME_NONNULL_BEGIN

@interface XQAppleDeviceModel : NSObject

/// 主类, 然后通过主类, 再判断下面的子类
@property (nonatomic, assign) XQAppleDevType type;

/// <#note#>
@property (nonatomic, assign) XQIPhoneDevType iPhoneSubtype;

/// <#note#>
@property (nonatomic, assign) XQIPodDevType iPodSubtype;

/// <#note#>
@property (nonatomic, assign) XQIPadDevType iPadSubtype;

/// <#note#>
@property (nonatomic, assign) XQAppleTVDevType appleTVSubtype;

/// <#note#>
@property (nonatomic, assign) XQIPhoneSimulatorDevType iPhoneSimulatorSubtype;



@end

NS_ASSUME_NONNULL_END
