//
//  XQOpenPanel.h
//  MacApp
//
//  Created by WXQ on 2018/1/15.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void(^XQOpenPanelCallback)(NSString *path);
typedef void(^XQOpenPanelCancelCallback)(void);

@interface XQOpenPanel : NSObject

/**
 <#Description#>

 @param window <#window description#>
 @param openCallback <#openCallback description#>
 @param cancelCallback <#cancelCallback description#>
 */
+ (void)beginSheetModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

/**
 选择图片
 */
+ (void)beginSheetImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

/**
 选择PNG图片
 */
+ (void)beginSheetPNGImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

+ (void)beginSheetModalWithWindow:(NSWindow *)window configPanel:(void(^)(NSOpenPanel *openPanel))configPanel openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

@end













