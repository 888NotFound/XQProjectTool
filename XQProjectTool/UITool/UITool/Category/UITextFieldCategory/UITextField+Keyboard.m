//
//  UITextField+Keyboard.m
//  Appollo4
//
//  Created by WXQ on 2018/7/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "UITextField+Keyboard.h"

#if !XQExtensionFramework
#import "NSObject+XQExchangeIMP.h"
#endif

@interface UITextField ()

@end

@implementation UITextField (Keyboard)

#if !XQExtensionFramework
+ (void)load {
    [self exchangeInstanceMethodWithOriginSEL:@selector(deleteBackward) otherSEL:@selector(xq_deleteBackward)];
}
#endif

- (void)xq_deleteBackward {
    [self xq_deleteBackward];
    if (self.delCallback) {
        self.delCallback();
    }
}

- (void)setDelCallback:(XQUITextFieldCallback)delCallback {
#if !XQExtensionFramework
    [NSObject xq_setAssociatedObject:self key:@"delCallback" value:delCallback policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
#endif
}

- (XQUITextFieldCallback)delCallback {
#if !XQExtensionFramework
    return [NSObject xq_getAssociatedObject:self key:@"delCallback"];
#else
    return nil;
#endif
}




@end






















