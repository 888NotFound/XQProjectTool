//
//  XQRegisterHotKey.m
//  XQTestHotKey
//
//  Created by WXQ on 2018/6/4.
//  Copyright © 2018年 SyKing. All rights reserved.
//



#import "XQRegisterHotKey.h"
#import <EventKit/EventKit.h>
#import <Carbon/Carbon.h>

@implementation XQRegisterHotKey

static XQRegisterHotKey *manager_ = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ = [XQRegisterHotKey new];
    });
    return manager_;
}

/**
 注册快捷键

 @param signature 自定义签名
 @param keyID 自定义keyid
 @param inHotKeyCode 热键的code, 例如 18代表1, 21代表4, 49代表空格键等等..
 @param modifiers 组合键 cmdKey, optionKey等等, 如果组合就是  cmdKey + optionKey
 @return 注册快捷键结果
 */
- (OSStatus)xq_registerCustomHotKeyWithSignature:(UInt32)signature
                                           keyID:(UInt32)keyID
                                    inHotKeyCode:(UInt32)inHotKeyCode
                                       modifiers:(XQModifiers)modifiers {
        // 1、声明相关参数
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec myEvenType;
    
    myEvenType.eventClass = kEventClassKeyboard;    // 键盘类型
    myEvenType.eventKind = kEventHotKeyPressed;     // 按压事件
    
        // 2、定义快捷键
    myHotKeyID.signature = signature;  // 自定义签名 'yuus'
    myHotKeyID.id = keyID;              // 快捷键ID 4
    
        // 3、注册快捷键
        // 参数一：keyCode; 如18代表1，19代表2，21代表4，49代表空格键，36代表回车键
        // 参数二: cmdKey, optionKey 等等..
        // 快捷键：command+4
    RegisterEventHotKey(inHotKeyCode, modifiers, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
        // 快捷键：command+option+4
    //RegisterEventHotKey(inHotKeyCode, cmdKey + optionKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
        // 5、注册回调函数，响应快捷键
    OSStatus status = InstallApplicationEventHandler(&xq_hotKeyHandler, 1, &myEvenType, NULL, NULL);
    //InstallEventHandler(<#EventTargetRef inTarget#>, <#EventHandlerUPP inHandler#>, <#ItemCount inNumTypes#>, <#const EventTypeSpec *inList#>, <#void *inUserData#>, <#EventHandlerRef *outRef#>)
    return status;
}

    // 4、自定义C类型的回调函数
OSStatus xq_hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
    EventHotKeyID hotKeyRef;
    GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyRef), NULL, &hotKeyRef);
    if ([manager_.delegate respondsToSelector:@selector(hotKeyHandlerWithSignature:keyID:)]) {
        [manager_.delegate hotKeyHandlerWithSignature:hotKeyRef.signature keyID:hotKeyRef.id];
    }
    return noErr;
}

@end











