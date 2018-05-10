//
//  XQGetAppInfo.m
//  MQTTProject
//
//  Created by WXQ on 2018/3/30.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "XQGetAppInfo.h"

@implementation XQGetAppInfo

+ (void)getAppInfoWithAPPID:(NSString *)appID success:(XQGetAppInfoSucceedBlock)success failure:(XQGetAppInfoFailureBlock)failure; {
    if (appID.length == 0) {
        if (failure) {
            failure([NSError errorWithDomain:@"wxq" code:46456456 userInfo:@{@"wxq": @"appid error"}]);
        }
        return;
    }
        // https://itunes.apple.com/cn/app/{APP名称}/id%@?mt=8, app名称是不能为中文的, 可以转码一下, 但是我发现, 好像填不填都无所谓..
    //NSString *url = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/cn/app/appollo/id%@?mt=8", appID];
    
    NSString *url = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/lookup?id=%@", appID];
    
    [self GET:url succeed:success failure:failure];
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //[manager POST:url parameters:@{} progress:nil success:success failure:failure];
}

+ (BOOL)openAPPStoreWithAppID:(NSString *)appID completionHandler:(void (^)(BOOL success))completion {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/appname/id%@?mt=8", appID];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:completion];
        } else {
            return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        return YES;
    }
    
    return NO;
}

+ (BOOL)openURLWithURLStr:(NSString *)urlStr completionHandler:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        return YES;
    }
    
    return NO;
}

#ifdef DEBUG
+ (void)getFirInfoWithToken:(NSString *)token bID:(NSString *)bID success:(XQGetAppInfoSucceedBlock)success failure:(XQGetAppInfoFailureBlock)failure {
    // 经本人测试...有关fir.im的代码, 都可能造成上架 2.5.2 原因....所以, 有关这部分代码, 都要用DEBUG框起来, 在release预编译的时候, 就不编译这段代码进去
    if (bID.length == 0 || token.length == 0) {
        if (failure) {
            failure([NSError errorWithDomain:@"wxq" code:46456456 userInfo:@{@"wxq": @"param error"}]);
        }
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=%@", bID, token];
    [self GET:url succeed:success failure:failure];
}
#endif

#pragma mark - POST请求
+ (NSURLSessionDataTask *)POST:(NSString *)URLStr param:(NSDictionary *)param succeed:(XQGetAppInfoSucceedBlock)succeed failure:(XQGetAppInfoFailureBlock)failure {
    if (![NSJSONSerialization isValidJSONObject:param]) {
        if (failure) {
            NSError *paramError = [NSError errorWithDomain:URLStr code:9999990 userInfo:@{@"errorMsg": @"错误参数"}];
            failure(paramError);
        }
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:URLStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10;
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [XQGetAppInfo getDataFromDic:param];
    [request setHTTPBody:jsonData];
    
    return [self request:request succeed:succeed failure:failure];
}

#pragma mark - Get请求
+ (NSURLSessionDataTask *)GET:(NSString *)URLStr succeed:(XQGetAppInfoSucceedBlock)succeed failure:(XQGetAppInfoFailureBlock)failure {
    
    NSString *pathStr = @"";
        // 汉字转码
    pathStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSURL *url = [NSURL URLWithString:pathStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10;
    
    return [self request:request succeed:succeed failure:failure];
}

#pragma mark -- 请求
+ (NSURLSessionDataTask *)request:(NSURLRequest *)request succeed:(XQGetAppInfoSucceedBlock)succeed failure:(XQGetAppInfoFailureBlock)failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
            
            return;
        }
        
        NSError *jError = nil;
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (jError) {
                if (failure) {
                    failure(jError);
                }
                
            }else {
                
                if (jsonData) {
                    if (succeed) {
                        succeed(jsonData);
                    }
                    
                }else {
                    if (failure) {
                        failure(jError);
                    }
                }
                
            }
            
        });
    }];
        //开始请求
    [task resume];
    return task;
}

#pragma mark - 数据字典转换二进制流
+ (NSData*)getDataFromDic:(NSDictionary *)dic {
    NSString *string = nil;
    NSArray *array = [dic allKeys];
    for (int i = 0; i<array.count; i++) {
        NSString *key = [array objectAtIndex:i];
        NSString *value = [dic valueForKey:key];
        if (i == 0) {
            string = [NSString stringWithFormat:@"%@=%@",key,value];
        }else {
            string = [NSString stringWithFormat:@"%@&%@=%@",string,key,value];
            
        }
    }
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

@end




















