//
//  NSViewController+XQAlert.m
//  AFNetworking
//
//  Created by WXQ on 2019/1/12.
//

#import "NSViewController+XQAlert.h"

@implementation NSViewController (XQAlert)


- (BOOL)xq_presentErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code {
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:nil];
    return [self presentError:error];
}

@end
