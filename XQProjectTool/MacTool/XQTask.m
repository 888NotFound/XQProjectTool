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
- (void)xq_executeBinShWithCmd:(NSString *)cmd {
    NSLog(@"cmd: %@", cmd);
    if ([self.task isRunning]) {
        NSLog(@"正在运行");
        return;
    }
    
    if (self.task) {
        [self xq_terminate];
    }
    
    __weak typeof(self) weakSelf = self;
    NSError *error = nil;
    NSTask *task = [[self class] launchedTaskWithExecutableURL:[NSURL fileURLWithPath:@"/bin/sh"] arguments:@[@"-c", cmd] error:&error outLogHandle:^(NSString *log) {
        NSLog(@"输出: %@", log);
    } errorLogHandle:^(NSString *log) {
        NSLog(@"错误: %@", log);
    } terminationHandler:^(NSTask * _Nonnull task) {
        NSLog(@"断开: %@", task);
        weakSelf.task = nil;
    }];
    
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    self.task = task;
    
    // 监听打印
//    [self xq_waitReadingForDataInBackgroundAndNotify];
    // 开始加载
//    [self.task launchAndReturnError:&error];
    // 等待结束
//    [self.task waitUntilExit];
}

/**
 监听脚本打印
 */
- (void)xq_waitReadingForDataInBackgroundAndNotify {
    __weak typeof(self.task) weakTask = self.task;
    
    // 监听输出
    NSPipe *outPipe = self.task.standardOutput;
    [outPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * note) {
        NSFileHandle *fh = note.object;
        // 获取当前输出的字符串
        NSData *data = fh.availableData;
        NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        if (result.length != 0) {
            NSLog(@"**** %@", result);
        }else {
            NSLog(@"xq_空");
        }
        
        // 结束的时候，数据都是空的, 然后并且 isRuning == NO
        
        if (weakTask.isRunning) {
            // 再次等待接收
            [fh waitForDataInBackgroundAndNotify];
        }else {
            NSLog(@"结束接收数据");
        }
    }];
}

/**
 监听输入
 测试下来, 其实就是监听控制台输入, 对于写成一个app来说, 这个是不需要的.
 直接, 调用 [[inPipe fileHandleForWriting] writeData:inData]; 就可以了
 */
- (void)xq_waitWritingForDataInBackgroundAndNotify {
    __weak typeof(self.task) weakTask = self.task;
    
    // 监听输入
    NSPipe *inPipe = self.task.standardInput;
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    // 等待输入...
    [input waitForDataInBackgroundAndNotify];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:input queue:nil usingBlock:^(NSNotification *note) {
        NSFileHandle *input = note.object;
        NSData *inData = [input availableData];
        NSString *inDataStr = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
        NSLog(@"input: %@, %@", note, inDataStr);
        if ([inData length] == 0) {
            [[inPipe fileHandleForWriting] closeFile];
        } else {
            [[inPipe fileHandleForWriting] writeData:inData];
        }
        
        if (weakTask.isRunning) {
            [input waitForDataInBackgroundAndNotify];
        }
    }];
}

/**
 监听错误
 */
- (void)xq_waitErrorForDataInBackgroundAndNotify {
    __weak typeof(self.task) weakTask = self.task;
    
    // 监听输出
    NSPipe *outPipe = self.task.standardError;
    [outPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * note) {
        NSFileHandle *fh = note.object;
        // 获取当前输出的字符串
        NSData *data = fh.availableData;
        NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        if (result.length != 0) {
            NSLog(@"error: %@", result);
        }else {
            NSLog(@"error: xq_空");
        }
        
        if (weakTask.isRunning) {
            // 再次等待接收
            [fh waitForDataInBackgroundAndNotify];
        }else {
            NSLog(@"error: 结束接收数据");
        }
    }];
}

- (void)xq_terminate {
    if (!self.task) {
        return;
    }
    
    if (self.task.isRunning) {
        [self.task terminate];
        self.task = nil;
        NSLog(@"%s", __func__);
    }
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
    [task waitUntilExit];
    
    return task;
}

@end

