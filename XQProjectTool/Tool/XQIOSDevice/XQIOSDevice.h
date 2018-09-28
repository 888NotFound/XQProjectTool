//
//  XQIOSDevice.h
//  XQAddProperty
//
//  Created by ladystyle100 on 2017/9/25.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, XQIOSDevType) {
    XQIOSDevTypeUnknow = 0,
    XQIOSDevTypeIPhone,
    XQIOSDevTypeIPod,
    XQIOSDevTypeIPad,
    XQIOSDevTypeAppleTV,
    XQIOSDevTypeSimulator,// 手机模拟器
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
    XQIPhoneDevType7,
    XQIPhoneDevType7Plus,
    XQIPhoneDevType8,
    XQIPhoneDevType8Plus,
    XQIPhoneDevTypeX,
    XQIPhoneDevTypeXS,
    XQIPhoneDevTypeXSMax,
    XQIPhoneDevTypeXR,
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

typedef struct _XQIOSDevModel {
    XQIOSDevType type;// 主类, 然后通过主类, 再判断下面的子类
    XQIPhoneDevType iPhoneSubtype;
    XQIPodDevType iPodSubtype;
    XQIPadDevType iPadSubtype;
    XQAppleTVDevType appleTVSubtype;
    XQIPhoneSimulatorDevType iPhoneSimulatorSubtype;
}XQIOSDevModel;


#define XQ_IPhoneType [XQIOSDevice getIPhoneType]

#define XQ_NHeight [XQIOSDevice getNavigationHeight]
#define XQ_StatusHeight [XQIOSDevice getStatusHeight]
#define XQ_TabBarHeight [XQIOSDevice getTabbarHeight]

@interface XQIOSDevice : NSObject

/**
 获取当前机型
 */
+ (XQIOSDevModel)getIOSDevType;

/**
 是否默认机型...就是iPhoneX为NO, iPhone7这种为YES
 */
+ (BOOL)isNormalModel;

/**
 获取nv bar高度
 */
+ (CGFloat)getNavigationHeight;

/**
 获取status bar高度
 */
+ (CGFloat)getStatusHeight;

/**
 获取tab bar高度
 */
+ (CGFloat)getTabbarHeight;

/**
 获取除去nv bar,tab bar高度
 */
+ (CGFloat)getSubNavAndTabHeight;

/**
 获取除去nv bar高度
 */
+ (CGFloat)getSubNavHeight;

/**
 获取当前机型, 这个是直接获取具体字符串, 可以判断更加细致的类型
 */
+ (NSString *)getIPhoneType;


@end








