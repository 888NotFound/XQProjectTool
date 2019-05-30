//
//  NSScrollView+XQScroll.h
//  XQArchiveProject
//
//  Created by WXQ on 2019/5/30.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSScrollView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^XQScrollCallback)(NSScrollView *scrollView);

@interface NSScrollView (XQScroll)

/**
 监听滚动视图

 @param callback 不要来里面引用自己(self), 不然会循环引用, 要用weak包一层
 
 @note 偏移量其实就是 scrollView.contentView.bounds, 我在这里返回 scrollView 出去, 外面直接判断 bounds 就行了
 */
- (void)xq_listenScrollWithCallback:(XQScrollCallback)callback;

@end

NS_ASSUME_NONNULL_END
