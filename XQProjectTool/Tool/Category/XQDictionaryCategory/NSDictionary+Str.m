//
//  NSDictionary+Str.m
//  XQTestIPhoneSSZipArchive
//
//  Created by WXQ on 2018/10/13.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "NSDictionary+Str.h"

@implementation NSDictionary (Str)


+ (NSDictionary *)xq_strToDicWithStr:(NSString *)str {
    NSDictionary *dic = nil;
    
    NSError *error = nil;
    dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"失败: %@", error);
    }
    return dic;
}




@end
