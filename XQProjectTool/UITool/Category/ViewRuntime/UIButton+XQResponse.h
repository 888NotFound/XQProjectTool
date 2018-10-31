//
//  UIButton+XQResponse.h
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQBtnClick)(UIButton *sender);

@interface UIButton (XQResponse)

/** 现在只有两个状态 touchUpInside and touchDown */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQBtnClick)callback;

@end
