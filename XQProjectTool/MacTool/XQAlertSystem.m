//
//  XQAlertSystem.m
//  MacApp
//
//  Created by WXQ on 2018/1/15.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQAlertSystem.h"

@implementation XQAlertSystem

+ (void)alertSheetWithTitle:(NSString *)title message:(NSString *)message contentArr:(NSArray <NSString *> *)contentArr callback:(XQAlertSystemCallback)callback {
    [self alertSheetWithTitle:title message:message img:[NSImage imageNamed:NSImageNameInfo] contentArr:contentArr window:[NSApplication sharedApplication].mainWindow style:NSAlertStyleInformational callback:callback];
}

+ (void)alertSheetWithTitle:(NSString *)title message:(NSString *)message img:(NSImage *)img contentArr:(NSArray <NSString *> *)contentArr window:(NSWindow *)window style:(NSAlertStyle)style callback:(XQAlertSystemCallback)callback {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:title];
    [alert setInformativeText:message];
        // 图标
    alert.icon = img;
        // 第一个按钮, 默认蓝色, 按回车键选中
        // 如没有按钮情况下, 系统会自动生成一个ok按钮, 并且点击的返回值为0
    for (NSString *str in contentArr) {
        [alert addButtonWithTitle:str];
    }
        // 弹框类型
        // NSAlertStyleCritical: 这个类型会在图标那里有个感叹号~, 其他两个没看出来有什么不同
    [alert setAlertStyle:style];
        // 显示弹框, result: 1000为第一个按钮, 后面自动叠加1
    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (callback) {
            callback(result);
        }
    }];
}

/* 保存图片到本地
NSImage *img = [NSImage imageNamed:NSImageNameInfo];
    // 锁住
[img lockFocus];
    //先设置 下面一个实例
NSBitmapImageRep *bits = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, img.size.width, img.size.height)];
    // 解锁
[img unlockFocus];
    //再设置后面要用到得 props属性
NSDictionary *imageProps = @{NSImageInterlaced: @(NO)};
    //之后 转化为NSData 以便存到文件中
NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];

NSString *path = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
NSString *savePath = [NSString stringWithFormat:@"%@/123.png", path];
NSLog(@"savePath = %@", savePath);
    //设定好文件路径后进行存储就ok了
[imageData writeToFile:savePath atomically:YES];
 */

@end















