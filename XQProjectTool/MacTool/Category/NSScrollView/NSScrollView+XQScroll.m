//
//  NSScrollView+XQScroll.m
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "NSScrollView+XQScroll.h"

#import "NSObject+XQExchangeIMP.h"

@interface NSScrollView ()

@end

@implementation NSScrollView (XQScroll)

- (void)xq_listenScrollWithCallback:(XQScrollCallback)callback {
//    self.postsBoundsChangedNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xq_notification_viewBoundsChanged:) name:NSViewBoundsDidChangeNotification object:self.contentView];
    
    [NSObject xq_setAssociatedObject:self key:@"xq_callback" value:callback policy:OBJC_ASSOCIATION_COPY];
}

- (void)xq_notification_viewBoundsChanged:(NSNotification *)sender {
    // 用 sender.object 防止多个 scrollView 一起监听
    if ([sender.object isEqual:self.contentView]) {
        XQScrollCallback callback = [NSObject xq_getAssociatedObject:self key:@"xq_callback"];
        if (callback) {
            callback(self);
        }
    }
    
}

@end
