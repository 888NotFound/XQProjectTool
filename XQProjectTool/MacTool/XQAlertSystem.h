//
//  XQAlertSystem.h
//  MacApp
//
//  Created by WXQ on 2018/1/15.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void(^XQAlertSystemCallback)(NSInteger index);

@interface XQAlertSystem : NSObject

+ (void)alertSheetWithTitle:(NSString *)title message:(NSString *)message contentArr:(NSArray <NSString *> *)contentArr callback:(XQAlertSystemCallback)callback;

@end



