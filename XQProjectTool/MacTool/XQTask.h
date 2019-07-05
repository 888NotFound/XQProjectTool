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
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSTask *> *taskDic;

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
 执行 bash 命令
 
 @param cmd 命令
 @param key 提前结束脚本要传入这个key
 @param outLogHandle 脚本文本输出
 @param errorLogHandle 脚本错误文本输出
 @param terminationHandler 脚本结束回调
 */
- (void)xq_executeBashWithCmd:(NSString *)cmd key:(NSString *)key error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler;

/**
 执行 sudo 命令
 
 @param cmd 命令
 @param key 提前结束脚本要传入这个key
 */
- (void)xq_executeSudoWithCmd:(NSString *)cmd key:(NSString *)key error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler;

/**
 结束脚本运行
 */
- (void)xq_terminateWithKey:(NSString *)key;

/**
 结束脚本所有运行
 */
- (void)xq_terminateAll;

@end

NS_ASSUME_NONNULL_END

