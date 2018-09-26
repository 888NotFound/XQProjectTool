//
//  XQPlayerMusic.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/26.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQPlayerMusic.h"
#import <AVFoundation/AVFoundation.h>

@interface XQPlayerMusic ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) BOOL isCirculate;

@end

@implementation XQPlayerMusic

static XQPlayerMusic *manager_ = nil;

+ (instancetype)manager {
    if (!manager_) {
        manager_ = [XQPlayerMusic new];
    }
    return manager_;
}

- (void)playWithFilePath:(NSString *)filePath isCirculate:(BOOL)isCirculate {
    if (self.player) {
        [self removeNotification];
        [self.player pause];
        self.player = nil;
    }
    
    if (filePath.length == 0) {
        [self stop];
        return;
    }
    
    NSURL *url  = [NSURL fileURLWithPath:filePath];
    if (!url) {
        [self stop];
        return;
    }
    
    self.filePath = filePath;
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
    self.isCirculate = isCirculate;
    [self addNotification];
}

- (void)stop {
    if (self.player) {
        [self.player pause];
        [self removeNotification];
    }
    manager_ = nil;
}

- (void)dealloc {
    NSLog(@"播放音乐释放");
}

/**
 *  添加播放器通知
 */
- (void)addNotification {
        //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成.");
    if (self.isCirculate) {
            // 播放完成后重复播放
            // 跳到最新的时间点开始播放
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    }else {
        [self stop];
    }
}

@end




















