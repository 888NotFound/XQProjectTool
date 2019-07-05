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
    [self autBiometricsWithIsMustFingerprint:NO callback:callback failureCallback:failureCallback];
}

+ (void)autBiometricsWithIsMustFingerprint:(BOOL)isMustFingerprint callback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback {
        //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验系统证锁屏指纹";
    
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
        //首先使用canEvaluatePolicy 判断设备支持状态
    LAPolicy policy = LAPolicyDeviceOwnerAuthentication;
    if (isMustFingerprint) {
        policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }
    
    if ([context canEvaluatePolicy:policy error:&error]) {
            //支持指纹验证
        [context evaluatePolicy:policy localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                    //验证成功，主线程处理UI
#if DEBUG
                NSLog(@"成功啦");
#endif
                    //用户选择输入密码，切换主线程处理
                if (callback) {
                    callback();
                }
                return ;
                
            }else {
#if DEBUG
                NSLog(@"手势验证失败 %@",error.localizedDescription);
#endif
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
                            // 授权失败, 验证了多次指纹开锁, 失败了, 先让用户密码开锁先
                        NSLog(@"LAErrorAuthenticationFailed");
                        [self autPwdWithContext:context isMustFingerprint:isMustFingerprint callback:callback failureCallback:failureCallback];
                        return;
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
                        // 用户选择要输入密码, 让他输入. 反正就算输入正确了, 还是跳到验证指纹这边来
                        NSLog(@"LAErrorUserFallback");
                        [self autPwdWithContext:context isMustFingerprint:isMustFingerprint callback:callback failureCallback:failureCallback];
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
//                        [self autPwdWithContext:context isMustFingerprint:isMustFingerprint callback:callback failureCallback:failureCallback];
                        NSLog(@"指纹验证 default");
                    }
                        break;
                }
                
                if (failureCallback) {
                    failureCallback(error);
                }
            }
            
        }];
        
        return;
        
    }else {
            // 不支持指纹识别，LOG出错误详情
#if DEBUG
        NSLog(@"手势不支持 %@", error.localizedDescription);
#endif
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled: {
                NSLog(@"TouchID is not enrolled");
            }
                break;
                
            case LAErrorPasscodeNotSet: {
                NSLog(@"A passcode has not been set");
                // 未设置密码
                error = [NSError errorWithDomain:@"wxq" code:-5 userInfo:nil];
            }
                break;
                
            case LAErrorNotInteractive:{
                NSLog(@"LAErrorNotInteractive");
            }
                break;
                
            case LAErrorBiometryLockout:{
                // 输入错误过多 或 指纹解锁多次, 被锁, 需要先输入密码解锁
                NSLog(@"LAErrorBiometryLockout");
                [self autPwdWithContext:context isMustFingerprint:isMustFingerprint callback:callback failureCallback:failureCallback];
                return;
            }
                break;

            case LAErrorBiometryNotAvailable:{
                NSLog(@"LAErrorBiometryNotAvailable");
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
                
            case LAErrorSystemCancel:{
                NSLog(@"LAErrorSystemCancel");
            }
                break;
                
            case LAErrorUserFallback:{
                NSLog(@"LAErrorUserFallback");
            }
                break;
                
            case LAErrorUserCancel:{
                // 取消
                NSLog(@"LAErrorUserCancel");
            }
                break;
            
            case LAErrorAuthenticationFailed:{
                NSLog(@"LAErrorAuthenticationFailed");
            }
                break;
                
            default: {
                NSLog(@"TouchID not available");
            }
                break;
        }
        
    }
    
    if (failureCallback) {
        failureCallback(error);
    }
}

+ (void)autPwdWithContext:(LAContext *)context isMustFingerprint:(BOOL)isMustFingerprint callback:(void(^)(void))callback failureCallback:(void(^)(NSError *error))failureCallback {
    // 报错码为-8时，调用此方法会弹出系统密码输入界面
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请输入系统锁屏密码" reply:^(BOOL success, NSError * _Nullable error){
        if (success) {
            if (isMustFingerprint) {
                [self autBiometricsWithIsMustFingerprint:isMustFingerprint callback:callback failureCallback:failureCallback];
            }else {
                if (callback) {
                    callback();
                }
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






















