//
//  XQTask.m
//  AFNetworking
//
//  Created by WXQ on 2019/1/14.
//


#import "XQTask.h"

@interface XQTask ()

// 系统
//NSAppleScript;
/** 系统执行脚本 */
@property (nonatomic, strong) NSAppleScript *aScript;

/** <#note#> */
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation XQTask

static XQTask *sm_ = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sm_ = [XQTask new];
    });
    return sm_;
}

/**
 */
+ (void)restart {
    [self multipleOpen];
    exit(0);
}

+ (void)multipleOpen {
    //获得本程序的路径
    NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
    //创建任务
    NSTask *task = [[NSTask alloc] init];
    //启动路径
    task.launchPath = @"/usr/bin/open";
    //添加参数
    task.arguments = @[@"-n", applicationPath];
    //启动
    [task launch];
}



#pragma mark -- 系统自带的
- (void)xq_appleScriptWithUrl:(NSURL *)url {
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"xq_shell" ofType:@"sh"];
    NSDictionary *dic = nil;
    self.aScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&dic];
    if (dic) {
        NSLog(@"%@", dic);
        return;
    }
    
    NSAppleEventDescriptor *descriptor = [self.aScript executeAndReturnError:&dic];
    if (dic) {
        NSLog(@"1 %@", dic);
    }
    
    NSLog(@"descriptor: %@", descriptor);
}


// 执行脚本
- (void)xq_executeBashWithCmd:(NSString *)cmd key:(NSString *)key error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    [self xq_executeBinShWithExecutableURL:[NSURL fileURLWithPath:@"/bin/bash"] cmd:cmd key:key error:error outLogHandle:outLogHandle errorLogHandle:errorLogHandle terminationHandler:terminationHandler];
}

// 执行脚本
- (void)xq_executeSudoWithCmd:(NSString *)cmd key:(NSString *)key error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    [self xq_executeBinShWithExecutableURL:[NSURL fileURLWithPath:@"/bin/sudo"] cmd:cmd key:key error:error outLogHandle:outLogHandle errorLogHandle:errorLogHandle terminationHandler:terminationHandler];
}

- (void)xq_executeBinShWithExecutableURL:(NSURL *)executableURL cmd:(NSString *)cmd key:(NSString *)key error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    // 每个执行任务都放不同线程
    // DISPATCH_QUEUE_SERIAL: 串行队列
    NSString *queueLabel = [NSString stringWithFormat:@"xq_task_%.0f", [NSDate date].timeIntervalSince1970];
    NSLog(@"cmd: %@", cmd);
    
    __weak typeof(self) weakSelf = self;
    
    //    @"/bin/sh"
    NSTask *task = [[self class] launchedTaskWithExecutableURL:executableURL arguments:@[@"-c", cmd] error:error outLogHandle:^(NSString *log) {
        if (outLogHandle) {
            outLogHandle(log);
        }
        
    } errorLogHandle:^(NSString *log) {
        if (errorLogHandle) {
            errorLogHandle(log);
        }
        
    } terminationHandler:^(NSTask * _Nonnull task) {
        NSLog(@"断开: %@", task);
        
        NSString *rKey = nil;
        for (NSString *key in weakSelf.taskDic.allKeys) {
            NSTask *sTask = weakSelf.taskDic[key];
            if ([sTask isEqual:task]) {
                NSLog(@"包含 task: %@", task);
                rKey = key;
            }
        }
        
        if (rKey) {
            [weakSelf.taskDic removeObjectForKey:rKey];
        }
        
        if (terminationHandler) {
            terminationHandler(task);
        }
    }];
    
    if (*error) {
        NSLog(@"执行错误 error: %@", *error);
    }else {
        
        if (key.length == 0) {
            key = [NSString stringWithFormat:@"xq_%.0f", [NSDate date].timeIntervalSince1970];
        }
        [self.taskDic addEntriesFromDictionary:@{key:task}];
        
        dispatch_async(dispatch_queue_create([queueLabel UTF8String], DISPATCH_QUEUE_SERIAL), ^{
            [task waitUntilExit];
            // 监听打印
            //    [self xq_waitReadingForDataInBackgroundAndNotify];
            // 开始加载
            //    [self.task launchAndReturnError:&error];
            // 等待结束
            //    [self.task waitUntilExit];
        });
    }
    
}

/**
 监听输入
 测试下来, 其实就是监听控制台输入, 对于写成一个app来说, 这个是不需要的.
 直接, 调用 [[inPipe fileHandleForWriting] writeData:inData]; 就可以了
 */
- (void)xq_waitWritingForDataInBackgroundAndNotify {
    /**
     其实主要就是把 task 的 standardInput 设置为 NSPipe
     然后获取 [standardInput fileHandleForWriting] 调用 writeData 方法
     */
    
//    __weak typeof(self.task) weakTask = self.task;
//
//    // 监听输入
//    NSPipe *inPipe = self.task.standardInput;
//    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
//    // 等待输入...
//    [input waitForDataInBackgroundAndNotify];
//
//    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:input queue:nil usingBlock:^(NSNotification *note) {
//        NSFileHandle *input = note.object;
//        NSData *inData = [input availableData];
//        NSString *inDataStr = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
//        NSLog(@"input: %@, %@", note, inDataStr);
//        if ([inData length] == 0) {
//            [[inPipe fileHandleForWriting] closeFile];
//        } else {
//            [[inPipe fileHandleForWriting] writeData:inData];
//        }
//
//        if (weakTask.isRunning) {
//            [input waitForDataInBackgroundAndNotify];
//        }
//    }];
}

- (void)xq_terminateWithKey:(NSString *)key; {
    if (!self.taskDic[key]) {
        NSLog(@"不存在任务");
        return;
    }

    if (self.taskDic[key].isRunning) {
        [self.taskDic[key] terminate];
    }else {
        [self.taskDic removeObjectForKey:key];
    }
    
    [self.taskDic removeObjectForKey:key];
}


/**
 结束脚本所有运行
 */
- (void)xq_terminateAll {
    NSLog(@"%s", __func__);
    
    NSDictionary *dic = self.taskDic.copy;
    for (NSString *key in dic.allKeys) {
        NSTask *task = dic[key];
        if (task.isRunning) {
            [task terminate];
        }
    }
    [self.taskDic removeAllObjects];
}

+ (nullable NSTask *)launchedTaskWithExecutableURL:(NSURL *)url arguments:(NSArray<NSString *> *)arguments error:(out NSError ** _Nullable)error outLogHandle:(void (^)(NSString *log))outLogHandle errorLogHandle:(void (^)(NSString *log))errorLogHandle terminationHandler:(void (^_Nullable)(NSTask *task))terminationHandler {
    
//    NSTask *task = [NSTask launchedTaskWithExecutableURL:url arguments:arguments error:error terminationHandler:terminationHandler];
    NSTask *task = [NSTask new];
    
    
    /** 这是是为了设置脚本参数
     Linux 的 Shell 种类众多,常见的有:
     
     Bourne Shell(/usr/bin/sh或/bin/sh)
     Bourne Again Shell(/bin/bash)
     C Shell(/usr/bin/csh)
     K Shell(/usr/bin/ksh)
     Shell for Root(/sbin/sh)
     */
    [task setLaunchPath:@"/bin/sh"];
    
    // 环境变量
    //    self.task.environment = @{@"GEM_PATH":@"/Users/huyuanjun/.rvm/gems/ruby-2.3.0/bin"};
    
    // -c 用来执行string-commands(命令字符串), 也就说不管后面的字符串里是什么都会被当做shellcode来执行
    task.arguments = arguments;
    
    // 输出
    NSPipe *outPipe = [NSPipe pipe];
    task.standardOutput = outPipe;
    
    // 输入
    NSPipe *inPipe = [NSPipe pipe];
    task.standardInput = inPipe;
    
    // 输入
    NSPipe *errorPipe = [NSPipe pipe];
    task.standardError = errorPipe;
    
    task.terminationHandler = terminationHandler;
    
    __weak typeof(task) weakTask = task;
    
    // 监听输出
    if (outLogHandle) {
        [outPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * note) {
            NSFileHandle *fh = note.object;
            // 获取当前输出的字符串
            NSData *data = fh.availableData;
            NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            if (result.length != 0) {
                outLogHandle(result);
            }
            
            // 结束的时候，数据都是空的, 然后并且 isRuning == NO
            if (weakTask.isRunning) {
                // 再次等待接收
                [fh waitForDataInBackgroundAndNotify];
            }
        }];
    }
    
    // 监听错误输出
    if (errorLogHandle) {
        [errorPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:errorPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * note) {
            NSFileHandle *fh = note.object;
            // 获取当前输出的字符串
            NSData *data = fh.availableData;
            NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            if (result.length != 0) {
                errorLogHandle(result);
            }
            
            if (weakTask.isRunning) {
                // 再次等待接收
                [fh waitForDataInBackgroundAndNotify];
            }
        }];
    }
    
    
    [task launchAndReturnError:error];
//    [task waitUntilExit];
    
    return task;
}


// 获取管理员权限
+ (NSDictionary *)getAdminAuthority {
    NSDictionary *error = nil;
    NSString *script =  @"do shell script \"/bin/ls\" with administrator privileges";
    
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    
    NSAppleEventDescriptor *des = [appleScript executeAndReturnError:&error];
    return error;
}

#pragma mark - get

- (NSMutableDictionary<NSString *,NSTask *> *)taskDic {
    if (!_taskDic) {
        _taskDic = [NSMutableDictionary dictionary];
    }
    return _taskDic;
}

@end

