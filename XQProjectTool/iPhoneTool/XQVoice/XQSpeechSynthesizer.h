//
//  XQSpeechSynthesizer.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/20.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XQSpeechSynthesizerLanguage) {
    XQSpeechSynthesizerLanguageChina = 0,// 普通话
    XQSpeechSynthesizerLanguageChinaHK,// 白话
    XQSpeechSynthesizerLanguageEnglish,// 英语
};

@interface XQSpeechSynthesizer : NSObject

/** 说什么语言 */
@property (nonatomic, assign) XQSpeechSynthesizerLanguage xqLanguage;

+ (instancetype)manager;

/**
 开始说话
 */
- (void)startSpeakWithText:(NSString *)text;

/**
 停止说话
 */
- (void)stop;

+ (XQSpeechSynthesizerLanguage)getLanguage;
+ (void)saveLanguage:(XQSpeechSynthesizerLanguage)language;

@end




















