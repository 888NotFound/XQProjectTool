//
//  XQSpeech.h
//  Speech
//
//  Created by WXQ on 2018/3/13.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

// 必须得10.0版本以上才能用
// Privacy - Speech Recognition Usage Description: 语言识别

#import <Foundation/Foundation.h>

@class XQSpeech;
typedef void(^XQSpeechCallback)(BOOL result);
typedef void(^XQSpeechResultCallback)(NSString *resultStr);

typedef NS_ENUM(NSInteger, XQSpeechLanguage) {
    XQSpeechLanguageChina = 0,// 普通话
    XQSpeechLanguageChinaHK,// 白话
    XQSpeechLanguageEnglish,// 英语
};

@protocol XQSpeechDelegate <NSObject>

    // 转录文字中
- (void)speechRecognitionTask:(XQSpeech *)task text:(NSString *)text;
    // 已经完成识别
- (void)speechRecognitionTask:(XQSpeech *)task didFinishRecognition:(NSString *)text;
    // 取消
- (void)speechRecognitionTaskWasCancelled:(XQSpeech *)task;
    // 已经完成
- (void)speechRecognitionTask:(XQSpeech *)task didFinishSuccessfully:(BOOL)successfully;

@end

@interface XQSpeech : NSObject

@property (nonatomic, weak) id <XQSpeechDelegate> delegate;

/** 说什么语言 */
@property (nonatomic, assign) XQSpeechLanguage xqLanguage;

+ (instancetype)manager;

/**
 开始录音, 并识别

 @param callback 返回NO, 表示, 权限问题, 或者设备不支持
 @param resultCallback 每次识别结果
 */
- (void)startRecognitionWithCallback:(XQSpeechCallback)callback resultCallback:(XQSpeechResultCallback)resultCallback;

/**
 停止录音
 
 @return 录音最终的文字
 */
- (NSString *)stopRecognition;

/**
 是否能识别语音
 
 @return YES可以, NO不可以, 如果是用户没确定, 那么会直接申请权限
 */
- (BOOL)isCanSpeech;

/**
 是否停止识别
 
 @return YES不在识别, NO正在识别
 */
- (BOOL)isStop;


+ (XQSpeechLanguage)getLanguage;
+ (void)saveLanguage:(XQSpeechLanguage)language;


@end
















