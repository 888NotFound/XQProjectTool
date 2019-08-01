//
//  XQSIMInfo.h
//  CMPageTitleView
//
//  Created by WXQ on 2019/8/1.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCarrier.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQSIMInfo : NSObject

/**
 获取运营商信息
 */
+ (nullable CTCarrier *)getFirstCarrierInfo;

/**
 获取运营商信息
 */
+ (nullable NSDictionary <NSString *, CTCarrier *> *)getCarrierInfo;

@end

NS_ASSUME_NONNULL_END