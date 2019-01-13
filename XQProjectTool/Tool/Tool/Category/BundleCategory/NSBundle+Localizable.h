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

/** 要改变的语言字符串
 en: 英文
 zh-Hans: 中文
 zh_Hans_HK: 香港
 zh_Hant_TW: 台湾
 */
+ (void)xq_setLanguage:(NSString *)language;

@end
