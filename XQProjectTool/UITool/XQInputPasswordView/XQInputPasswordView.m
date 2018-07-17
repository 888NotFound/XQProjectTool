//
//  XQInputPasswordView.m
//  XQTestOneDemo
//
//  Created by WXQ on 2018/7/6.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQInputPasswordView.h"
#import "CAShapeLayer+Common.h"
#import "CATextLayer+Common.h"

#define xq_screen_width     ([[UIScreen mainScreen] bounds].size.width)
#define xq_screen_height    ([[UIScreen mainScreen] bounds].size.height)

@interface XQInputPasswordView() <UIKeyInput>

@property (nonatomic, strong) NSMutableString *text;

@end

@implementation XQInputPasswordView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _text = [[NSMutableString alloc] init];
    _xq_keyboardType = UIKeyboardTypeNumberPad;
    _pwLength = 6;
    _isSecure = YES;
    
    _boxTopY = 1;
    _boxLeftSpacing = 15;
    _boxRightSpacing = 15;
    _boxSpacing = 10;
    _boxColor = [UIColor blackColor];
    _boxLinewidth = 2;
    _boxFillColor = [UIColor clearColor];
    
    _fontSize = 20;
    _fontColor = [UIColor blackColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawRectangle];
    [self drawDot];
}

// 是否可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
}

#pragma mark -- UIKeyInput

- (void)deleteBackward {
    if (self.text.length == 0) {
        [self.delegate inputPasswordViewDidDelText:self];
        return;
    }
    [self.text deleteCharactersInRange:NSMakeRange(self.text.length - 1, 1)];
    [self.delegate inputPasswordViewDidDelText:self];
    
    [self drawDot];
}

- (void)insertText:(nonnull NSString *)text {
    if (self.text.length >= self.pwLength) {
        [self.delegate inputPasswordViewDidInsertTextOutBounds:self outBoundsText:text];
        return;
    }
    [self.text appendString:text];
    if (self.text.length > self.pwLength) {
        [self.text deleteCharactersInRange:NSMakeRange(self.pwLength - 1, self.text.length - self.pwLength)];
    }
    
    [self.delegate inputPasswordViewDidInsertText:self];
    
    [self drawDot];
}

- (BOOL)hasText {
    return self.text.length != 0;
}

#pragma mark -- UITextInputTraits

- (UIKeyboardType)keyboardType {
    return self.xq_keyboardType;
}

#pragma mark -- 画图
// 画框
- (void)drawRectangle {
    NSArray *arr = self.layer.sublayers.copy;
    for (CALayer *layer in arr) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat size = (self.bounds.size.width - (self.boxSpacing * (self.pwLength - 1)) - self.boxLeftSpacing - self.boxRightSpacing) / self.pwLength;
    CGFloat y = ((self.bounds.size.height - size)/2) * self.boxTopY;
    for (int i = 0; i < self.pwLength; i++) {
        CGRect rect = CGRectMake(self.boxLeftSpacing + (self.boxSpacing + size) * i, y, size, size);
        CAShapeLayer *layer = [CAShapeLayer rectangleLayerWithRect:rect color:self.boxFillColor strokeColor:self.boxColor lineWidth:self.boxLinewidth];
        [self.layer addSublayer:layer];
    }
}

// 画圆点
- (void)drawDot {
    NSArray *arr = self.layer.sublayers.copy;
    for (CALayer *layer in arr) {
        if ([layer isKindOfClass:[CATextLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat size = (self.bounds.size.width - (self.boxSpacing * (self.pwLength - 1)) - self.boxLeftSpacing - self.boxRightSpacing) / self.pwLength;
    for (int i = 0; i < self.passwordStr.length; i++) {
        CGRect rect = CGRectMake(self.boxLeftSpacing + (self.boxSpacing + size) * i, self.boxTopY + (size - self.fontSize) / 2, size, self.fontSize);
        
        CATextLayer *layer = nil;
        if (self.isSecure) {
            layer = [CATextLayer textLayerWithStr:@"*" strColor:self.fontColor font:[UIFont systemFontOfSize:self.fontSize] frame:rect];
        }else {
            layer = [CATextLayer textLayerWithStr:[self.passwordStr substringWithRange:NSMakeRange(i, 1)] strColor:self.fontColor font:[UIFont systemFontOfSize:self.fontSize] frame:rect];
        }
        [self.layer addSublayer:layer];
    }
    
}

#pragma mark -- set

- (void)setIsSecure:(BOOL)isSecure {
    _isSecure = isSecure;
    
    [self drawDot];
}

- (void)setBoxTopY:(NSUInteger)boxTopY {
    _boxTopY = boxTopY;
    
    [self drawRectangle];
    [self drawDot];
}

- (void)setBoxSpacing:(NSUInteger)boxSpacing {
    _boxSpacing = boxSpacing;
    
    [self drawRectangle];
    [self drawDot];
}

- (void)setPasswordStr:(NSString *)passwordStr {
    self.text = passwordStr.mutableCopy;
    if (self.text.length > self.pwLength) {
        [self.text deleteCharactersInRange:NSMakeRange(self.pwLength - 1, self.text.length - self.pwLength)];
    }
    
    [self drawDot];
}

- (void)setPwLength:(NSUInteger)pwLength {
    _pwLength = pwLength;
    
    [self drawRectangle];
    [self drawDot];
}

#pragma mark -- get

- (NSString *)passwordStr {
    return self.text;
}

@end



















