//
//  XQSpeechSynthesizer.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/20.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

@interface XQSpeechSynthesizer () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;// 声明语音合成器

@end

@implementation XQSpeechSynthesizer

static XQSpeechSynthesizer *manager_ = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ = [XQSpeechSynthesizer new];
        manager_.synthesizer = [[AVSpeechSynthesizer alloc] init];
        manager_.synthesizer.delegate = manager_;
        manager_.xqLanguage = [self getLanguage];
    });
    return manager_;
}

- (void)startSpeakWithText:(NSString *)text  {
    // 先停止
    [self stop];
    
    NSString *language = @"zh-CN";
    switch (self.xqLanguage) {
        case XQSpeechSynthesizerLanguageChinaHK:
            language = @"zh-HK";
            break;
            
        case XQSpeechSynthesizerLanguageEnglish:
            language = @"en-US";
            break;
            
        default:
            break;
    }
    /** 语音
     *  zh-CN 普通话
     *  zh-HK 香港
     *  zh-TW 台湾
     *  en-GB 英国
     *  en-US 美国
     */
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    AVSpeechUtterance *utterrance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterrance.voice = voice;
        // 语速 0 ~ 1
    utterrance.rate = AVSpeechUtteranceDefaultSpeechRate;
        // 声调 0.5 ~ 2
    //utterrance.pitchMultiplier = 2;
        // 音量 0 ~ 1
    utterrance.volume = 1;
        // 延迟
        //    utterrance.preUtteranceDelay
        //    utterrance.postUtteranceDelay
    // 设置允许播放
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    [self.synthesizer speakUtterance:utterrance];
}

    // 暂停
- (void)respondsToPlayer:(id)sender {
        // 不在翻译中, 已暂停
    if (!self.synthesizer.isSpeaking || self.synthesizer.isPaused) {
        return;
    }
    
        // 暂停播放
    [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}

    // 取消
- (void)stop {
        // 不在翻译中
    if (!self.synthesizer.isSpeaking) {
        NSLog(@"并不在翻译中");
        return;
    }
        // 取消播放
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

    // 继续
- (void)respondsToCoutine:(id)sender {
        // 不在翻译中, 未暂停
    if (!self.synthesizer.isSpeaking || !self.synthesizer.isPaused) {
        return;
    }
        // 恢复播放
    [self.synthesizer continueSpeaking];
}

#pragma mark -- AVSpeechSynthesizerDelegate

    // 已经开始解读文字
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"didStartSpeechUtterance");
}

    // 结束解读文字
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"didFinishSpeechUtterance");
}

    // 暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"didPauseSpeechUtterance");
}

    // 恢复
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"didContinueSpeechUtterance");
}

    // 取消
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"didCancelSpeechUtterance");
}

    // 即将某范围的文字转为语音
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    NSLog(@"willSpeakRangeOfSpeechString");
}


+ (XQSpeechSynthesizerLanguage)getLanguage {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"xq_XQSpeechSynthesizer_language"];
}

+ (void)saveLanguage:(XQSpeechSynthesizerLanguage)language {
    [[NSUserDefaults standardUserDefaults] setObject:@(language) forKey:@"xq_XQSpeechSynthesizer_language"];
}


@end















