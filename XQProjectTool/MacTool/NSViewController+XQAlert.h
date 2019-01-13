//
//  NSViewController+XQAlert.h
//  AFNetworking
//
//  Created by WXQ on 2019/1/12.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSViewController (XQAlert)

- (BOOL)xq_presentErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
