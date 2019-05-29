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
 bash
 
 @param cmd 命令
 */
- (void)xq_executeBashWithCmd:(NSString *)cmd;

/**
 执行命令
 sudo 
 
 @param cmd 命令
 */
- (void)xq_executeSudoWithCmd:(NSString *)cmd;

/**
 自己制定执行

 @param executableURL 执行的命令
 @param cmd 具体参数
 */
- (void)xq_executeBinShWithExecutableURL:(NSURL *)executableURL cmd:(NSString *)cmd;

/**
 结束脚本运行
 */
- (void)xq_terminate;

@end

NS_ASSUME_NONNULL_END

