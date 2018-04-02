//
//  XQPermissionJude.m
//  PermissionJudge
//
//  Created by ladystyle100 on 2017/4/27.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "XQPermissionJudge.h"
#import <UserNotifications/UserNotifications.h>// 10.0推送
#import <AVFoundation/AVFoundation.h>// 相机
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>// 相册
#import <CoreLocation/CoreLocation.h>// 定位
#import <CoreBluetooth/CoreBluetooth.h>// 蓝牙
#import <Contacts/Contacts.h>// 通讯录
#import <Speech/Speech.h>// 语音识别

#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, XQOpenURL) {
    XQOpenURLCamera = 0,
    XQOpenURLPhoto,
    XQOpenURLLocation,
    XQOpenURLMicrophone,
    XQOpenURLBluetooth,
    XQOpenURLAddressBook,
    XQOpenURLNotification,
};

/** 设备版本 */
#define XQDV [[UIDevice currentDevice].systemVersion floatValue]

@implementation XQPermissionJudge

+ (BOOL)isPermissionCameraShowAlert:(BOOL)isAlert {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized && authStatus != AVAuthorizationStatusNotDetermined) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLCamera title:@"提示" message:@"使用该功能需同意App使用相机权限"];
        }
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionPhotoShowAlert:(BOOL)isAlert {
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus != PHAuthorizationStatusAuthorized && photoAuthorStatus != PHAuthorizationStatusNotDetermined) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLPhoto title:@"提示" message:@"使用该功能需要App使用相册"];
        }
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionLocationShowAlert:(BOOL)isAlert {
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLLocation title:@"提示" message:@"使用该功能需要App使用定位"];
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionMicrophoneShowAlert:(BOOL)isAlert {
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLMicrophone title:@"提示" message:@"使用该功能需要App使用麦克风"];
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionBluetoothShowAlert:(BOOL)isAlert {
    CBPeripheralManagerAuthorizationStatus cbAuthStatus = [CBPeripheralManager authorizationStatus];
    if (cbAuthStatus != CBPeripheralManagerAuthorizationStatusAuthorized) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLBluetooth title:@"提示" message:@"使用该功能需要App使用蓝牙"];
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionAddressBookShowAlert:(BOOL)isAlert {
    CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (cnAuthStatus != CNAuthorizationStatusAuthorized) {
        if (isAlert) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLAddressBook title:@"提示" message:@"使用该功能需要App使用通讯录"];
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPermissionNotificationShowAlert:(BOOL)isAlert {
    if (@available(iOS 10.0, *)) {
        __block BOOL isPermission = NO;
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
                isPermission = NO;
                if (isAlert) {
                    [XQPermissionJudge judgeWithIndex:XQOpenURLNotification title:@"提示" message:@"使用该功能需要App打开通知"];
                }
            }else {
                isPermission = YES;
            }
            
        }];
        return isPermission;
    } else {
        BOOL isPermission = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        if (!isPermission) {
            [XQPermissionJudge judgeWithIndex:XQOpenURLNotification title:@"提示" message:@"使用该功能需要App打开通知"];
        }
        return isPermission;
    }
}

+ (BOOL)isPermissionSpeechShowAlert:(BOOL)isAlert {
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus speechStatus = [SFSpeechRecognizer authorizationStatus];
        if (speechStatus == SFSpeechRecognizerAuthorizationStatusDenied ||
            speechStatus == SFSpeechRecognizerAuthorizationStatusRestricted) {
            
            if (isAlert) {
                [XQPermissionJudge judgeWithIndex:XQOpenURLNotification title:@"提示" message:@"使用该功能需要App打开语音识别"];
            }
            
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}



/**
 *  @param index     选择打开xxx
 */
+ (BOOL)judgeWithIndex:(XQOpenURL)index title:(NSString *)title message:(NSString *)message {
    // 相机，相册，定位，麦克风，蓝牙，通讯录，通知
    NSArray *URLStrArr = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    URLStrArr = @[@"App-Prefs:root=Privacy&path=CAMERA",
                  @"App-Prefs:root=Privacy&path=PHOTOS",
                  @"App-Prefs:root=Privacy&path=LOCATION_SERVICES",
                  @"App-Prefs:root=Privacy&path=MICROPHONE",
                  @"App-Prefs:root=Privacy&path=BLUETOOTH",
                  @"App-Prefs:root=Privacy&path=MICROPHONE",
                  @"App-Prefs:root=Privacy&path=NOTIFICATIONS_ID"];
#else 
    URLStrArr = @[@"prefs:root=Privacy&path=CAMERA",
                  @"prefs:root=Privacy&path=Photos",
                  @"prefs:root=Privacy&path=LOCATION_SERVICES",
                  @"prefs:root=Privacy&path=MICROPHONE",
                  @"prefs:root=Privacy&path=Bluetooth",
                  @"prefs:root=Privacy&path=MICROPHONE",
                  @"prefs:root=Privacy&path=NOTIFICATIONS_ID"];
#endif
    
    if (URLStrArr == nil || index > URLStrArr.count) {
        return NO;
    }
    
    NSURL *url = [NSURL URLWithString:URLStrArr[index]];
    
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:url]) {
        __weak UIApplication *weakApp = application;
        [XQPermissionJudge alertWithTitle:title message:message sure:^{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            [weakApp openURL:url options:@{} completionHandler:nil];
#else
            [weakApp openURL:url];
#endif
        }];
        
        return YES;
    }
    
    return NO;
}

// alert
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sure:(void(^)(void))sure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sure) {
            sure();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

/*
 10.0以下
 蜂窝网络：prefs:root=MOBILE_DATA_SETTINGS_ID
 Wi-Fi：prefs:root=WIFI
 定位服务：prefs:root=LOCATION_SERVICES
 个人热点：prefs:root=INTERNET_TETHERING
 关于本机：prefs:root=General&path=About
 辅助功能：prefs:root=General&path=ACCESSIBILITY
 飞行模式：prefs:root=AIRPLANE_MODE
 锁定：prefs:root=General&path=AUTOLOCK
 亮度：prefs:root=Brightness
 蓝牙：prefs:root=Bluetooth
 时间设置：prefs:root=General&path=DATE_AND_TIME
 FaceTime：prefs:root=FACETIME
 设置：prefs:root=General
 设置 prefs:root=SETTING
 定位服务 prefs:root=LOCATION_SERVICES
 键盘设置：prefs:root=General&path=Keyboard
 iCloud：prefs:root=CASTLE
 iCloud备份：prefs:root=CASTLE&path=STORAGE_AND_BACKUP
 语言：prefs:root=General&path=INTERNATIONAL
 定位：prefs:root=LOCATION_SERVICES
 音乐：prefs:root=MUSIC
 麦克风：prefs:root=Privacy&path=MICROPHONE
 
 10.0以上
 Wi-Fi: App-Prefs:root=WIFI
 蓝牙: App-Prefs:root=Bluetooth
 蜂窝移动网络: App-Prefs:root=MOBILE_DATA_SETTINGS_ID
 个人热点: App-Prefs:root=INTERNET_TETHERING
 运营商: App-Prefs:root=Carrier
 通知: App-Prefs:root=NOTIFICATIONS_ID
 通用: App-Prefs:root=General
 通用-关于本机: App-Prefs:root=General&path=About
 通用-键盘: App-Prefs:root=General&path=Keyboard
 通用-辅助功能: App-Prefs:root=General&path=ACCESSIBILITY
 通用-语言与地区: App-Prefs:root=General&path=INTERNATIONAL
 通用-还原: App-Prefs:root=Reset
 墙纸: App-Prefs:root=Wallpaper
 Siri: App-Prefs:root=SIRI
 隐私: App-Prefs:root=Privacy
 定位: App-Prefs:root=LOCATION_SERVICES
 Safari: App-Prefs:root=SAFARI
 音乐: App-Prefs:root=MUSIC
 音乐-均衡器: App-Prefs:root=MUSIC&path=com.apple.Music:EQ
 照片与相机: App-Prefs:root=Photos
 FaceTime: App-Prefs:root=FACETIME
 麦克风：App-Prefs:root=Privacy&path=MICROPHONE
 
 
 电池电量 Prefs:root=BATTERY_USAGE
 通用设置 Prefs:root=General
 存储空间 Prefs:root=General&path=STORAGE_ICLOUD_USAGE/DEVICE_STORAGE
 蜂窝数据 Prefs:root=MOBILE_DATA_SETTINGS_ID
 Wi-Fi 设置 Prefs:root=WIFI
 蓝牙设置 Prefs:root=Bluetooth
 定位设置 Prefs:root=Privacy&path=LOCATION
 辅助功能 Prefs:root=General&path=ACCESSIBILITY
 关于手机 Prefs:root=General&path=About
 键盘设置 Prefs:root=General&path=Keyboard
 显示设置 Prefs:root=DISPLAY
 声音设置 Prefs:root=Sounds
 App Store 设置 Prefs:root=STORE
 墙纸设置 Prefs:root=Wallpaper
 打开电话 Mobilephone://
 世界时钟 Clock-worldclock://
 闹钟 Clock-alarm://
 秒表 Clock-stopwatch://
 倒计时 Clock-timer://
 打开相册 Photos://
 
 */

@end

















