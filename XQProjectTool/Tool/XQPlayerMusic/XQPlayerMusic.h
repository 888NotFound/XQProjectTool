//
//  XQPlayerMusic.h
//  MQTTProject
//
//  Created by WXQ on 2018/3/26.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQPlayerMusic : NSObject

+ (instancetype)manager;

/**
 播放本地铃声

 @param filePath 文件路径, 现在是只能本地文件
 @param isCirculate NO播放一次 YES循环
 */
- (void)playWithFilePath:(NSString *)filePath isCirculate:(BOOL)isCirculate;

/**
 停止播放
 */
- (void)stop;

@end
