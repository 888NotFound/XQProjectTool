//
//  UITextField+Keyboard.m
//  Appollo4
//
//  Created by WXQ on 2018/7/5.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "UITextField+Keyboard.h"
#import "NSObject+XQExchangeIMP.h"

@interface UITextField ()

@end

@implementation UITextField (Keyboard)

+ (void)load {
    [self exchangeInstanceMethodWithOriginSEL:@selector(deleteBackward) otherSEL:@selector(xq_deleteBackward)];
}

- (void)xq_deleteBackward {
    [self xq_deleteBackward];
    if (self.delCallback) {
        self.delCallback();
    }
}

- (void)setDelCallback:(XQUITextFieldCallback)delCallback {
    [NSObject xq_setAssociatedObject:self key:@"delCallback" value:delCallback policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (XQUITextFieldCallback)delCallback {
    return [NSObject xq_getAssociatedObject:self key:@"delCallback"];
}




@end






















