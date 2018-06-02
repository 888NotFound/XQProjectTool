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
    if (self.player && [self.filePath isEqualToString:filePath]) {
        return;
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
    AVPlayer * player = [[AVPlayer alloc] initWithURL:url];
    [player play];
    self.player = player;
    if (isCirculate) {
        [self addNotification];
    }
}

- (void)stop {
    [self.player pause];
    [self removeNotification];
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
        // 播放完成后重复播放
        // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

@end




















