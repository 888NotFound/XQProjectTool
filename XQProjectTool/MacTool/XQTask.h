//
//  XQTask.h
//  AFNetworking
//
//  Created by WXQ on 2019/1/14.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQTask : NSObject

/**  */
@property (nonatomic, strong, nullable) NSTask *task;

+ (instancetype)manager;

/**
 重启
 */
+ (void)restart;

/**
 多开
 */
+ (void)multipleOpen;

/**
 执行 NSAppleScript 脚本
 
 @param url 苹果的脚本路径
 */
- (void)xq_appleScriptWithUrl:(NSURL *)url;

/**
 执行命令
 
 @param cmd 命令
 */
- (void)xq_executeBinShWithCmd:(NSString *)cmd;

/**
 结束脚本运行
 */
- (void)xq_terminate;

@end

NS_ASSUME_NONNULL_END

