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

+ (void)beginSheetModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

+ (void)beginSheetImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

+ (void)beginSheetPNGImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

+ (void)beginSheetModalWithWindow:(NSWindow *)window configPanel:(void(^)(NSOpenPanel *openPanel))configPanel openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback;

@end













