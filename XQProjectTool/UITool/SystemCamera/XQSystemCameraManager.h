//
//  XQSystemCameraManager.h
//  智家二维码
//
//  Created by WXQ on 2018/5/30.
//  Copyright © 2018年 农宝财. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XQSystemCameraManagerCallback)(NSArray *resultArr);

@interface XQSystemCameraManager : NSObject

/**
 开始扫描
 */
+ (BOOL)startScanWithCallback:(XQSystemCameraManagerCallback)callback;

/**
 开始扫描

 @param rectOfInterest (0, 0, 1, 1) 值是 0~1, (y,x,h,w), 其实就是手机屏幕横着来, 原点在右上角  ...其实这个..还有点问题, 感觉总不对
 @param callback 扫描结果
 */
+ (BOOL)startScanWithRectOfInterest:(CGRect)rectOfInterest callback:(XQSystemCameraManagerCallback)callback;

/**
 传入frame获取预览摄像头的layer
 */
+ (CALayer *)getVideoLayerWithFrame:(CGRect)frame;

/**
 开始扫描
 */
+ (void)start;
/**
 停止扫描
 */
+ (void)stop;

@end






















