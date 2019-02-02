//
//  XQOpenPanel.m
//  MacApp
//
//  Created by WXQ on 2018/1/15.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#if TARGET_OS_OSX

#import "XQOpenPanel.h"

@implementation XQOpenPanel

+ (void)beginSheetModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback {
    [self beginSheetModalWithWindow:window configPanel:nil openCallback:openCallback cancelCallback:cancelCallback];
}

+ (void)beginSheetImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback {
    [self beginSheetModalWithWindow:window configPanel:^(NSOpenPanel *openPanel) {
        openPanel.canChooseFiles = YES;
        [openPanel setAllowedFileTypes:@[@"jpg", @"jpeg", @"png"]];
    } openCallback:openCallback cancelCallback:cancelCallback];
}

+ (void)beginSheetPNGImageModalWithWindow:(NSWindow *)window openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback {
    [self beginSheetModalWithWindow:window configPanel:^(NSOpenPanel *openPanel) {
        openPanel.canChooseFiles = YES;
        [openPanel setAllowedFileTypes:@[@"png"]];
    } openCallback:openCallback cancelCallback:cancelCallback];
}

+ (void)beginSheetModalWithWindow:(NSWindow *)window configPanel:(void(^)(NSOpenPanel *openPanel))configPanel openCallback:(XQOpenPanelCallback)openCallback cancelCallback:(XQOpenPanelCancelCallback)cancelCallback {
//    [panel setAllowedFileTypes:@[@"onecodego"]];
    // 创建通道打开对象
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    //是否可以创建文件夹
    openPanel.canCreateDirectories = YES;
    //是否可以选择文件夹
    openPanel.canChooseDirectories = YES;
    //是否可以选择文件
    openPanel.canChooseFiles = NO;
    //是否可以多选
    openPanel.allowsMultipleSelection = NO;
    if (configPanel) {
        configPanel(openPanel);
    }
    __weak typeof(openPanel) weakPanel = openPanel;
    
    if (window) {
        //显示在控制器自身的window上, 就是App的主window
        [openPanel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
            //是否点击open 按钮
            if (result == NSModalResponseOK) {
                NSString *pathString = [weakPanel.URLs.firstObject path];
                if (openCallback) {
                    openCallback(pathString);
                }
                
            }else {
                if (cancelCallback) {
                    cancelCallback();
                }
            }
        }];
        
    }else {
        // 悬浮电脑主window上
        [openPanel beginWithCompletionHandler:^(NSInteger result) {
            //是否点击open 按钮
            if (result == NSModalResponseOK) {
                NSString *pathString = [openPanel.URLs.firstObject path];
                if (openCallback) {
                    openCallback(pathString);
                }
                
            }else {
                if (cancelCallback) {
                    cancelCallback();
                }
            }
        }];
    }
}


@end




#endif









