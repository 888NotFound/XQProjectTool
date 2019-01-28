//
//  UIButton+XQResponse.h
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
typedef void(^XQBtnClick)(UIButton *sender);
@interface UIButton (XQResponse)

#else

#import <Cocoa/Cocoa.h>
typedef void(^XQBtnClick)(NSButton *sender);
@interface NSButton (XQResponse)

#endif


#if TARGET_OS_IPHONE
/** 现在只有两个状态 touchUpInside and touchDown */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQBtnClick)callback;
#endif

@end
