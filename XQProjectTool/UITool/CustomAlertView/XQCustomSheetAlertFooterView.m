//
//  XQCustomSheetAlertFooterView.m
//  Appollo4
//
//  Created by WXQ on 2018/6/21.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQCustomSheetAlertFooterView.h"
#import <Masonry/Masonry.h>

@implementation XQCustomSheetAlertFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        self.btn = [UIButton new];
        self.btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(10);
        }];
        
        [self.btn addTarget:self action:@selector(respondsToBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)respondsToBtn {
    self.callback();
}

@end
