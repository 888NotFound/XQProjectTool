//
//  XQSpeech.m
//  Speech
//
//  Created by WXQ on 2018/3/13.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import "XQSpeech.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

API_AVAILABLE(ios(10.0))
@interface XQSpeech () <SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate>

@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, copy) XQSpeechCallback callback;
@property (nonatomic, copy) XQSpeechResultCallback resultCallback;

@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *request;
@property (nonatomic, strong) SFSpeechRecognitionTask *task;
@property (nonatomic, strong) AVAudioEngine *audioEngine;

/** 记录文字 */
@property (nonatomic, copy) NSString *resultStr;

@end

@implementation XQSpeech

static XQSpeech *_manager;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [XQSpeech new];
    });
    return _manager;
}

#pragma mark -- 一边录一边识别

// 开始识别
- (void)startRecognitionWithCallback:(XQSpeechCallback)callback resultCallback:(XQSpeechResultCallback)resultCallback {
    self.callback = callback;
    self.resultCallback = resultCallback;
    if (@available(iOS 10.0, *)) {
        [self getMicrophoneAuthorization];
    }else {
        NSLog(@"版本过低");
        [self callbackWithResult:NO];
    }
}

// 获取麦克风权限
- (void)getMicrophoneAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
                //没有询问是否开启麦克风
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    [self getSpeechAuthorization];
                }else {
                    NSLog(@"用户拒绝");
                    [self callbackWithResult:NO];
                }
            }];
        }
            return;
            
        case AVAuthorizationStatusAuthorized: //授权
            [self getSpeechAuthorization];
            break;
            
        case AVAuthorizationStatusRestricted: //未授权，家长限制
        case AVAuthorizationStatusDenied: //未授权
            NSLog(@"没有权限");
            [self callbackWithResult:NO];
            return;
            
        default:
            break;
    }
}

// 获取语言识别权限
- (void)getSpeechAuthorization {
    if (@available(iOS 10.0, *)) {
        if ([SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusRestricted ||
            [SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusDenied) {
            NSLog(@"没有权限");
            [self callbackWithResult:NO];
            return;
        }else if ([SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    [self startRecognition];
                }else {
                    NSLog(@"用户拒绝");
                    [self callbackWithResult:NO];
                }
            }];
            
        }else {
            [self startRecognition];
        }
    }
}

// 开始录音, 并识别
- (void)startRecognition {
    [self stopRecognition];
    
    NSError *error = nil;
    //AVAudioSessionCategoryPlayAndRecord, 需要播放, 也需要录音
    // AVAudioSessionCategoryRecord, 需要录音
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        NSLog(@"error = %@", error);
        [self callbackWithResult:NO];
        return;
    }
    
    if (!self.audioEngine.inputNode) {
        NSLog(@"Audio engine has no input node");
        [self callbackWithResult:NO];
        [self stopRecognition];
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.task = [self.recognizer recognitionTaskWithRequest:self.request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (weakSelf.resultCallback) {
                weakSelf.resultCallback(result.bestTranscription.formattedString);
            }
            
            weakSelf.resultStr = result.bestTranscription.formattedString;
            
//            for (SFTranscription *transcription in result.transcriptions) {
//                NSLog(@"other %@", transcription.formattedString);
//            }
        }];
    }
    
    AVAudioFormat *recordingFormat = [self.audioEngine.inputNode outputFormatForBus:0];
    __weak typeof(self.request) weakRequest = self.request;
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"error = %@", error);
        [self callbackWithResult:NO];
        [self stopRecognition];
        return;
    }
}

- (NSString *)stopRecognition {
    if (@available(iOS 10.0, *)) {
        if (self.task) {
            [self.audioEngine.inputNode removeTapOnBus:0];
            [self.audioEngine stop];
            [self.task cancel];
            [self.request endAudio];
            self.audioEngine = nil;
            self.task = nil;
            self.request = nil;
        }
    }
    
    NSString *str = self.resultStr;
    self.resultStr = @"";
    return str;
}

#pragma mark -- 识别音频文件

- (void)recognitionWithFilePath:(NSString *)path callback:(XQSpeechCallback)callback resultCallback:(XQSpeechResultCallback)resultCallback {
    self.callback = callback;
    
    // 版本
    if (@available(iOS 10.0, *)) {
        
    }else {
        NSLog(@"版本过低");
        [self callbackWithResult:NO];
        return;
    }
    
    if (path.length == 0) {
        NSLog(@"路径错误");
        [self callbackWithResult:NO];
        return;
    }
    
    if (self.request) {
        NSLog(@"正在识别中");
        [self callbackWithResult:NO];
        return;
    }
    
    self.resultCallback = resultCallback;
    
    if (@available(iOS 10.0, *)) {
        if ([SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusRestricted ||
            [SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusDenied) {
            NSLog(@"权限拒绝");
            [self callbackWithResult:NO];
            return;
        }else if ([SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    [self recognitionWithFilePath:path];
                }else {
                    [self callbackWithResult:NO];
                }
            }];
            return;
        }
    }
    
    [self recognitionWithFilePath:path];
}

- (void)recognitionWithFilePath:(NSString *)path {
    if (!self.recognizer.available) {
        NSLog(@"语音识别不可用");
        [self callbackWithResult:NO];
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url) {
        [self callbackWithResult:NO];
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
        request.taskHint = SFSpeechRecognitionTaskHintDictation;
        self.task = [self.recognizer recognitionTaskWithRequest:request delegate:self];
    }
    [self callbackWithResult:YES];
}

- (void)callbackWithResult:(BOOL)result {
    if (self.callback) {
        self.callback(result);
    }
    self.callback = nil;
}

- (void)setXqLanguage:(XQSpeechLanguage)xqLanguage {
    if (@available(iOS 10.0, *)) {
        if (self.task) {
            return;
        }
        
        NSString *language = @"zh-CN";
        switch (xqLanguage) {
            case XQSpeechLanguageChinaHK:
                language = @"zh-HK";
                break;
                
            case XQSpeechLanguageEnglish:
                language = @"en-US";
                break;
                
            default:
                break;
        }
        
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:language]];
        _recognizer.delegate = self;
    }
}

- (BOOL)isCanSpeech {
    if (@available(iOS 10.0, *)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        SFSpeechRecognizerAuthorizationStatus speechStatus = [SFSpeechRecognizer authorizationStatus];
        if (authStatus == AVAuthorizationStatusAuthorized && speechStatus == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            return YES;
        }
        
        if (authStatus == AVAuthorizationStatusNotDetermined) {
                //没有询问是否开启麦克风
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
            }];
        }
        
        if (speechStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                
            }];
        }
        
        return NO;
    }
    
    return NO;
}

- (BOOL)isStop {
    if (@available(iOS 10.0, *)) {
        if (self.task) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -- SFSpeechRecognizerDelegate

    // 可用性发生改变
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available  API_AVAILABLE(ios(10.0)){
    //NSLog(@"availabilityDidChange = %d", available);
}

#pragma mark -- SFSpeechRecognitionTaskDelegate

    // 已经发现语言
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task  API_AVAILABLE(ios(10.0)){
    //NSLog(@"speechRecognitionDidDetectSpeech");
}

    // 已经假设转录
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription  API_AVAILABLE(ios(10.0)){
    //self.label.text = transcription.formattedString;
    NSLog(@"didHypothesizeTranscription = %@", transcription.formattedString);
    
    if ([self.delegate respondsToSelector:@selector(speechRecognitionTask:text:)]) {
        [self.delegate speechRecognitionTask:self text:transcription.formattedString];
    }
        // 识别文本信息
        // transcription.formattedString
    
        // 识别节点数组
        // transcription.segments
    
    /** SFTranscriptionSegment
     *  param substring: 当前节点识别后的文本信息
     *  param substringRange: 当前节点识别后的文本信息在整体识别语句中的位置
     *  param timestamp: 当前节点的音频时间戳
     *  param duration: 当前节点音频的持续时间
     *  param confidence: 可信度/准确度 0-1之间
     *  param alternativeSubstrings: 关于此节点的其他可能的识别结果
     */
}

    // 已经完成识别
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult  API_AVAILABLE(ios(10.0)){
    self.request = nil;
    if (self.resultCallback) {
        self.resultCallback(recognitionResult.bestTranscription.formattedString);
        self.resultCallback = nil;
    }
    if ([self.delegate respondsToSelector:@selector(speechRecognitionTask:didFinishRecognition:)]) {
        [self.delegate speechRecognitionTask:self didFinishRecognition:recognitionResult.bestTranscription.formattedString];
    }
}

    // 已经读取完音频
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task  API_AVAILABLE(ios(10.0)){
    if (task.error) {
        NSLog(@"error = %@", task.error);
        self.request = nil;
    }
}

    // 取消
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task  API_AVAILABLE(ios(10.0)){
    self.request = nil;
    if ([self.delegate respondsToSelector:@selector(speechRecognitionTaskWasCancelled:)]) {
        [self.delegate speechRecognitionTaskWasCancelled:self];
    }
}

    // 已经完成
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully  API_AVAILABLE(ios(10.0)){
    if ([self.delegate respondsToSelector:@selector(speechRecognitionTask:didFinishSuccessfully:)]) {
        [self.delegate speechRecognitionTask:self didFinishSuccessfully:successfully];
    }
}

#pragma mark -- get

- (SFSpeechRecognizer *)recognizer  API_AVAILABLE(ios(10.0)){
    if (!_recognizer) {
        NSString *language = @"zh-CN";
        switch ([XQSpeech getLanguage]) {
            case XQSpeechLanguageChinaHK:
                language = @"zh-HK";
                break;
                
            case XQSpeechLanguageEnglish:
                language = @"en-US";
                break;
                
            default:
                break;
        }
        
        // 默认中文
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:language]];
        _recognizer.delegate = self;
    }
    return _recognizer;
}

- (SFSpeechAudioBufferRecognitionRequest *)request  API_AVAILABLE(ios(10.0)){
    if (!_request) {
        _request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        _request.taskHint = SFSpeechRecognitionTaskHintDictation;
        // 提高识别率,
//        _request.contextualStrings = @[@"开", @"关", @"打开", @"关闭", @"全开", @"全关", @"启动", @"执行", @"开启", @"情景", @"大厅灯", @"厕所灯"];
//        _request.interactionIdentifier = @"全关";
            // 是否报告部分语音
        _request.shouldReportPartialResults = YES;
    }
    return _request;
}

- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}


+ (XQSpeechLanguage)getLanguage {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"xq_XQSpeech_language"];
}

+ (void)saveLanguage:(XQSpeechLanguage)language {
    [[NSUserDefaults standardUserDefaults] setObject:@(language) forKey:@"xq_XQSpeech_language"];
}

@end















