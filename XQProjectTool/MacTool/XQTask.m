//
//  XQTask.m
//  AFNetworking
//
//  Created by WXQ on 2019/1/14.
//

#if TARGET_OS_OSX

#import "XQTask.h"

@implementation XQTask


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


@end

#endif
