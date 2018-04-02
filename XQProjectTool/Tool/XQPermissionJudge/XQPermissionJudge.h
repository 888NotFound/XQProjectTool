//
//  XQPermissionJude.h
//  PermissionJudge
//
//  Created by ladystyle100 on 2017/4/27.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQPermissionJudge : NSObject
/** 相机
 *  @prama isAlert  YES，没授权情况下，显示弹框，让用户跳到设置里面
 *  @prama return   YES，已授权
 */
+ (BOOL)isPermissionCameraShowAlert:(BOOL)isAlert;

/** 相册 */
+ (BOOL)isPermissionPhotoShowAlert:(BOOL)isAlert;

/** 定位 */
+ (BOOL)isPermissionLocationShowAlert:(BOOL)isAlert;

/** 麦克风 */
+ (BOOL)isPermissionMicrophoneShowAlert:(BOOL)isAlert;

/** 蓝牙 */
+ (BOOL)isPermissionBluetoothShowAlert:(BOOL)isAlert;

/** 通讯录 */
+ (BOOL)isPermissionAddressBookShowAlert:(BOOL)isAlert;

/** 通知 */
+ (BOOL)isPermissionNotificationShowAlert:(BOOL)isAlert;

/** 语音识别 */
+ (BOOL)isPermissionSpeechShowAlert:(BOOL)isAlert;

@end







