//
//  XQCustomAlertView.m
//  Appollo4
//
//  Created by WXQ on 2018/5/21.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQCustomAlertView.h"
#import <Masonry/Masonry.h>

#import "UIView+XQLine.h"

#import "XQCustomSheetAlertView.h"

static BOOL tapBackHide_ = NO;

@interface XQCustomAlertView ()

@property (nonatomic, copy) XQCustomAlertViewCallback rightCallback;
@property (nonatomic, copy) XQCustomAlertViewTFCallback tfCllback;
@property (nonatomic, assign) BOOL tapBackHide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerTFHeightCons;

@end

@implementation XQCustomAlertView

static XQCustomAlertView *caView_ = nil;

/**
 中间弹框
 
 @param titleArr 最多两个, 至少没有
 @param callback index 是点击第几个
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message titleArr:(NSArray <NSString *> *)titleArr callback:(XQCustomAlertViewCallback)callback {
    if (caView_) {
        return;
    }
    
    [self initViewWithTitle:title message:message titleArr:titleArr];
    caView_.rightCallback = callback;
    caView_.centerTFHeightCons.constant = 0;
    
    [self show];
}

/**
 中间弹框
 
 @param tfCallback 返回tf出去, 给外面设置需要的属性
 */
+ (void)showTFWithTitle:(NSString *)title message:(NSString *)message titleArr:(NSArray <NSString *> *)titleArr tfCallback:(void(^)(UITextField *tf))tfCallback callback:(XQCustomAlertViewTFCallback)callback {
    if (caView_) {
        return;
    }
    
    [self initViewWithTitle:title message:message titleArr:titleArr];
    caView_.tfCllback = callback;
    caView_.centerTF.hidden = NO;
    
    if (titleArr.count == 0) {
        caView_.centerBtnTopCons.constant = 10;
    }
    
    if (tfCallback) {
        tfCallback(caView_.centerTF);
    }
    
    [self show];
}

+ (void)initViewWithTitle:(NSString *)title message:(NSString *)message titleArr:(NSArray <NSString *> *)titleArr {
    caView_ = [[NSBundle bundleForClass:[XQCustomAlertView class]] loadNibNamed:@"XQCustomAlertView" owner:nil options:nil].firstObject;
    caView_.alertLab.text = title;
    caView_.messageLab.text = message;
    
    caView_.tapBackHide = tapBackHide_;
    
    
    if (titleArr.count == 2) {
        [caView_.rightBtn setTitle:titleArr[1] forState:UIControlStateNormal];
        [caView_.leftBtn setTitle:titleArr[0] forState:UIControlStateNormal];
        
    }else if (titleArr.count == 1) {
        [caView_.centerBtn setTitle:titleArr[0] forState:UIControlStateNormal];
        caView_.centerBtn.hidden = NO;
        caView_.leftBtn.hidden = YES;
        caView_.rightBtn.hidden = YES;
        
    }else {
        caView_.centerBtnTopCons.constant = 0;
        caView_.centerBtnHeightCons.constant = 0;
        caView_.leftBtn.hidden = YES;
        caView_.rightBtn.hidden = YES;
        
    }
}

+ (void)show {
    if (!caView_) {
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:caView_];
    [caView_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [caView_ show];
}

+ (void)hide {
    if (caView_) {
        [caView_ hide];
    }
}

/**
 设置当前点击背景
 tapBackHide YES点击背景隐藏
 */
+ (void)setCurrenTapBackHide:(BOOL)tapBackHide {
    if (caView_) {
        caView_.tapBackHide = tapBackHide;
    }
}

+ (void)setTapBackHide:(BOOL)tapBackHide {
    tapBackHide_ = tapBackHide;
    [self setCurrenTapBackHide:tapBackHide];
}

/**
 底部弹框
 如果不要标题和副标题, 填 nil or @"", 但是取消按钮, 不要的话, 必须要填 nil
 
 @param cancalCallback -1点击背景
 */
+ (void)sheetWithTitle:(NSString *)title message:(NSString *)message dataArr:(NSArray <NSString *> *)dataArr cancelText:(NSString *)cancelText callback:(XQCustomSheetAlertViewCallback)callback cancelCallback:(XQCustomSheetAlertViewCallback)cancalCallback {
    [XQCustomSheetAlertView sheetWithTitle:title message:message dataArr:dataArr cancelText:cancelText callback:callback cancelCallback:cancalCallback];
}

/**
 设置多个按钮颜色
 */
+ (void)setItemColorWithColor:(UIColor *)color rows:(NSArray <NSNumber *> *)rows {
    [XQCustomSheetAlertView setItemColorWithColor:color rows:rows];
}

/**
 设置某个按钮为某个颜色
 */
+ (void)setItemColorWithColor:(UIColor *)color row:(NSInteger)row {
    [XQCustomSheetAlertView setItemColorWithColor:color row:row];
}

/**
 设置取消按钮为某个颜色
 */
+ (void)setCancelItemColorWithColor:(UIColor *)color {
    [XQCustomSheetAlertView setCancelItemColorWithColor:color];
}

#pragma mark -- 实例方法

- (void)awakeFromNib {
    [super awakeFromNib];
        // 默认没颜色
    self.alertView.layer.cornerRadius = 4;
    self.alertView.layer.masksToBounds = YES;
    
    self.alpha = 0;
    
    self.backView = [UIButton new];
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self insertSubview:self.backView atIndex:0];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backView addTarget:self action:@selector(respondsToBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark -- notification

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    if (self.centerTF.hidden) {
        return;
    }
    
    CGRect keyFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = self.alertView.frame;
    rect.origin.y = keyFrame.origin.y - rect.size.height - 20;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.frame = rect;
    }];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    if (self.centerTF.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsDisplay];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView setBorderWithView:self.centerBtn top:YES left:NO bottom:NO right:NO borderColor:[UIColor lightGrayColor] borderWidth:1];
    [UIView setBorderWithView:self.rightBtn top:YES left:NO bottom:NO right:NO borderColor:[UIColor lightGrayColor] borderWidth:1];
    [UIView setBorderWithView:self.leftBtn top:YES left:NO bottom:NO right:YES borderColor:[UIColor lightGrayColor] borderWidth:1];
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [self.centerTF endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        caView_ = nil;
    }];
}

- (IBAction)respondsToRight:(id)sender {
    [self hide];
    if (self.rightCallback) {
        self.rightCallback(1);
    }
    
    if (self.tfCllback) {
        self.tfCllback(self.centerTF, 1);
    }
}

- (IBAction)respondsToCenter:(id)sender {
    [self hide];
    if (self.rightCallback) {
        self.rightCallback(0);
    }
    
    if (self.tfCllback) {
        self.tfCllback(self.centerTF, 0);
    }
}

- (IBAction)respondsToLeft:(id)sender {
    [self hide];
    if (self.rightCallback) {
        self.rightCallback(0);
    }
    
    if (self.tfCllback) {
        self.tfCllback(self.centerTF, 0);
    }
}

- (void)respondsToBack:(id)sender {
    if (self.tapBackHide) {
        [self hide];
        
        if (self.rightCallback) {
            self.rightCallback(-1);
        }
        
        if (self.tfCllback) {
            self.tfCllback(self.centerTF, -1);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"弹框view释放");
}

@end
















