//
//  XQLocalAut.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/19.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQLocalAut.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation XQLocalAut

+ (BOOL)getIsOpenLocalAut {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"xq_saveIsOpenLocalAut"];
}

+ (void)saveIsOpenLocalAut:(BOOL)isOpen {
    [[NSUserDefaults standardUserDefaults] setBool:isOpen forKey:@"xq_saveIsOpenLocalAut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSError *)isSupport {
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    return error;
}

+ (void)autBiometricsWithCallback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback {
        //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验系统证锁屏指纹";
    
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
        //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
            //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                    //验证成功，主线程处理UI
                NSLog(@"成功啦");
                    //用户选择输入密码，切换主线程处理
                if (callback) {
                    callback();
                }
                return ;
                
            }else {
                NSLog(@"手势验证失败 %@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel: {
                            //系统取消授权，如其他APP切入
                        NSLog(@"LAErrorSystemCancel");
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                            //用户取消验证Touch ID
                        NSLog(@"LAErrorUserCancel");
                    }
                        break;
                        
                    case LAErrorAuthenticationFailed:{
                            //授权失败
                        NSLog(@"LAErrorAuthenticationFailed");
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                            //系统未设置密码
                        NSLog(@"LAErrorPasscodeNotSet");
                    }
                        break;
                        
                    case LAErrorTouchIDNotAvailable: {
                            //设备Touch ID不可用，例如未打开
                        NSLog(@"LAErrorTouchIDNotAvailable");
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                            //设备Touch ID不可用，用户未录入
                        NSLog(@"LAErrorTouchIDNotEnrolled");
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        // 选择输入密码
                        NSLog(@"LAErrorUserFallback");
                        [self autPwdWithContext:context callback:callback failureCallback:failureCallback];
                        return;
                    }
                        break;
                        
                    case LAErrorNotInteractive:{
                        NSLog(@"LAErrorNotInteractive");
                    }
                        break;
                        
                    case LAErrorInvalidContext:{
                        NSLog(@"LAErrorInvalidContext");
                    }
                        break;
                        
                    case LAErrorAppCancel:{
                        NSLog(@"LAErrorAppCancel");
                    }
                        break;
                        
                    default: {
                        [self autPwdWithContext:context callback:callback failureCallback:failureCallback];
                    }
                        return ;
                }
                
                if (failureCallback) {
                    failureCallback(error);
                }
            }
            
        }];
        
        return;
        
    }else {
            //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled: {
                NSLog(@"TouchID is not enrolled");
            }
                break;
                
            case LAErrorPasscodeNotSet: {
                NSLog(@"A passcode has not been set");
                error = [NSError errorWithDomain:@"wxq" code:-5 userInfo:nil];
            }
                break;
                
            case LAErrorNotInteractive:{
                NSLog(@"LAErrorNotInteractive");
            }
                break;
                
//            case LAErrorBiometryLockout:{// 输入错误过多, 被锁, 需要输入密码
//                NSLog(@"LAErrorBiometryLockout");
//            }
//                break;
//
//            case LAErrorBiometryNotAvailable:{
//                NSLog(@"LAErrorBiometryNotAvailable");
//            }
//                break;
                
            case LAErrorInvalidContext:{
                NSLog(@"LAErrorInvalidContext");
            }
                break;
                
            case LAErrorAppCancel:{
                NSLog(@"LAErrorAppCancel");
            }
                break;
                
            case LAErrorSystemCancel:{
                NSLog(@"LAErrorSystemCancel");
            }
                break;
                
            case LAErrorUserFallback:{
                NSLog(@"LAErrorUserFallback");
            }
                break;
                
            case LAErrorUserCancel:{
                NSLog(@"LAErrorUserCancel");
            }
                break;
            
            case LAErrorAuthenticationFailed:{
                NSLog(@"LAErrorAuthenticationFailed");
            }
                break;
                
            default: {
                NSLog(@"TouchID not available");
                [self autPwdWithContext:context callback:callback failureCallback:failureCallback];
            }
                return;
        }
        
        NSLog(@"手势不支持 %@", error.localizedDescription);
    }
    
    if (failureCallback) {
        failureCallback(error);
    }
    return;
}

+ (void)autPwdWithContext:(LAContext *)context callback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback {
    //报错码为-8时，调用此方法会弹出系统密码输入界面
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请输入系统锁屏密码" reply:^(BOOL success, NSError * _Nullable error){
        if (success) {
            if (callback) {
                callback();
            }
        }else {
            NSLog(@"密码验证失败 %@", error.localizedDescription);
            if (failureCallback) {
                failureCallback(error);
            }
        }
        
    }];
}

@end






















