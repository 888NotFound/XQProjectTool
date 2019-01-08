//
//  XQCustomSheetAlertTopView.m
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQCustomSheetAlertTopView.h"
#import <Masonry/Masonry.h>

#define XQ_Screen_Width [UIScreen mainScreen].bounds.size.width
#define XQ_Screen_Height [UIScreen mainScreen].bounds.size.height

@implementation XQCustomSheetAlertTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLab = [UILabel new];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont systemFontOfSize:17];
        self.messageLab = [UILabel new];
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.font = [UIFont systemFontOfSize:15];
        self.messageLab.textColor = [UIColor grayColor];
        
        [self addSubview:self.titleLab];
        [self addSubview:self.messageLab];
        self.messageLab.numberOfLines = 0;
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
        
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(10);
            make.left.equalTo(self.titleLab.mas_left);
            make.right.equalTo(self.titleLab.mas_right);
        }];
        
    }
    return self;
}

- (CGFloat)getViewHeight {
    if (self.titleLab.text.length == 0 && self.messageLab.text.length == 0) {
        return 0;
    }
    
    CGSize titleSize = [self.titleLab sizeThatFits:CGSizeMake(XQ_Screen_Width - 30, MAXFLOAT)];
    CGSize messageSize = [self.messageLab sizeThatFits:CGSizeMake(XQ_Screen_Width - 30, MAXFLOAT)];
    
    if (self.titleLab.text.length == 0) {
        [self.messageLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
        return messageSize.height + 10 + 10;
    }else if (self.messageLab.text.length == 0) {
        return titleSize.height + 10 + 10;
    }
    CGFloat height = 10 + titleSize.height + 10 + messageSize.height + 10;
    return height;
}

@end




















