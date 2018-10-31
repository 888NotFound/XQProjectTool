//
//  XQCustomSheetAlertTopView.h
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCustomSheetAlertTopView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *messageLab;

/**
 在赋值给title和message之后, 返回高度
 */
- (CGFloat)getViewHeight;

@end
