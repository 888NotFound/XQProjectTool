//
//  XQRegisterHotKey.h
//  XQTestHotKey
//
//  Created by WXQ on 2018/6/4.
//  Copyright © 2018年 SyKing. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt16, XQModifiers) {
    /* modifiers */
    XQModifiersActiveFlagBit                 = 1<< 0,    /* activate? (activateEvt and mouseDown)*/
    XQModifiersBtnStateBit                   = 1<< 7,    /* state of button?*/
    XQModifiersCmdKeyBit                     = 1<< 8,    /* command key down?*/
    XQModifiersShiftKeyBit                   = 1<< 9,    /* shift key down?*/
    XQModifiersAlphaLockBit                  = 1<< 10,   /* alpha lock down?*/
    XQModifiersOptionKeyBit                  = 1<< 11,   /* option key down?*/
    XQModifiersControlKeyBit                 = 1<< 12,   /* control key down?*/
    XQModifiersRightShiftKeyBit              = 1<< 13,   /* right shift key down? Not supported on Mac OS X.*/
    XQModifiersRightOptionKeyBit             = 1<< 14,   /* right Option key down? Not supported on Mac OS X.*/
    XQModifiersRightControlKeyBit            = 1<< 15    /* right Control key down? Not supported on Mac OS X.*/
};

@protocol XQRegisterHotKeyDelegate <NSObject>

@optional

/// 触发键盘监听回调
/// @param signature 自定义 signature
/// @param keyID 自定义 keyId
- (void)hotKeyHandlerWithSignature:(UInt32)signature keyID:(UInt32)keyID;

@end

@interface XQRegisterHotKey : NSObject

+ (instancetype)manager;

@property (nonatomic, weak) id <XQRegisterHotKeyDelegate> delegate;

/**
 注册快捷键
 
 @param signature 自定义签名
 @param keyID 自定义keyid
 @param inHotKeyCode 热键的code, 例如 18代表1, 21代表4, 49代表空格键, 53esc键等等..
 具体可以调用 [NSEvent addLocalMonitorForEventsMatchingMask:] 这个方法, 自己试一下所有键位的按钮keycode
 
 @param modifiers 和普通键的组合键,
 例如: XQModifiersCmdKeyBit = command,
 XQModifiersCmdKeyBit | XQModifiersOptionKeyBit = command + option
 
 如果 inHotKeyCode 21, modifiers XQModifiersCmdKeyBit, 那么就是 command + 4, 就会触发回调
 
 @return 注册快捷键结果 0成功.
 
 @note 示例代码: [[XQRegisterHotKey manager] xq_registerCustomHotKeyWithSignature:100 keyID:101 inHotKeyCode:18 modifiers:XQModifiersCmdKeyBit];
 这样的就设置了监听 command + 1, 只要用户触发, 就会在 XQRegisterHotKeyDelegate 中回调
 并且 signature 和 keyID, 返回的是 100 和 101
 
 */
- (OSStatus)xq_registerCustomHotKeyWithSignature:(UInt32)signature
                                           keyID:(UInt32)keyID
                                    inHotKeyCode:(UInt32)inHotKeyCode
                                       modifiers:(XQModifiers)modifiers;

@end





