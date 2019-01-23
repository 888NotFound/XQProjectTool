//
//  NSBundle+Localizable.h
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XQ_ChangeLanguage @"xq_changeLanguage"

@interface NSBundle (Localizable)


/**
 改变当前bundle语言
 */
- (void)xq_setLanguage:(NSString *)language;

/**
 改变MainBundle的语言
 */
+ (void)xq_setMainBundleLanguage:(NSString *)language;

/**
 改变语言

 @param language 要改变的语言
 en: 英文
 zh-Hans: 中文
 zh-Hant: 香港
 zh-HK: 台湾
 @param bundle 改变的bundle
 */
+ (void)xq_setLanguage:(NSString *)language bundle:(NSBundle *)bundle;



@end
