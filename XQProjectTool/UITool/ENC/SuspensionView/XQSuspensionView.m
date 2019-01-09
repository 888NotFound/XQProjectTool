//
//  XQSuspensionView.m
//  XQSuspensionView
//
//  Created by WXQ on 2018/5/24.
//  Copyright © 2018年 SyKing. All rights reserved.
//



#import "XQSuspensionView.h"
#import <Masonry/Masonry.h>

static XQSuspensionView *sView_ = nil;

#define XQ_Screen_Width [UIScreen mainScreen].bounds.size.width
#define XQ_Screen_Height [UIScreen mainScreen].bounds.size.height

@interface XQSuspensionView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/** 当前视图类型 */
@property (nonatomic, assign) XQSuspensionViewType type;
/** 当前视图类型 */
@property (nonatomic, assign) XQSuspensionViewType beforeType;

@property (nonatomic, strong) UIView *normalView;
@property (nonatomic, strong) UIView *smallRectangleView;
@property (nonatomic, strong) UIView *rectangleView;
@property (nonatomic, strong) UIView *roundView;

/** 视图开始的point */
@property (nonatomic, assign) CGPoint originPoint;
/** 开始的手势point */
@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation XQSuspensionView

/**
 显示
 
 @param normalView 全屏view, 以下如同
 @param type 显示的样式
 */
+ (void)showWithNormalView:(UIView *)normalView
             rectangleView:(UIView *)rectangleView
        smallRectangleView:(UIView *)smallRectangleView
                 roundView:(UIView *)roundView
                      type:(XQSuspensionViewType)type {
    if (sView_) {
        NSLog(@"已存在view");
        return;
    }
    
    sView_ = [XQSuspensionView new];
    sView_.type = type;
    [sView_ addPanGesture];
    
    sView_.normalView = normalView;
    sView_.smallRectangleView = smallRectangleView;
    sView_.rectangleView = rectangleView;
    sView_.roundView = roundView;
#if !XQExtensionFramework
    [[XQApplication sharedApplication].keyWindow addSubview:sView_];
#endif
    [sView_ refreshViewType];
}

/**
 隐藏view
 */
+ (void)hide {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    [sView_ hide];
}

/**
 获取当前view的类型
 */
+ (XQSuspensionViewType)getCurrentType {
    if (!sView_) {
        NSLog(@"不存在view");
        return XQSuspensionViewTypeHide;
    }
    return sView_.type;
}

/**
 改变view的类型
 */
+ (void)setCurrentType:(XQSuspensionViewType)type {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    
    sView_.beforeType = sView_.type;
    sView_.type = type;
    [sView_ refreshViewType];
}

/**
 变回上一个viewType
 */
+ (void)changeBeforeType {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    XQSuspensionViewType type = sView_.beforeType;
    sView_.beforeType = sView_.type;
    sView_.type = type;
    [sView_ refreshViewType];
}

/**
 设置view的背景颜色
 */
+ (void)setViewBackColor:(UIColor *)backColor {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    
    sView_.backgroundColor = backColor;
}

/**
 获取当前的view
 */
+ (XQSuspensionView *)getCurrentView {
    return sView_;
}

/**
 设为最顶层的view, 就是每次, 如果要在window上加view的话...那么就得设置window最顶层
 */
+ (void)setWindowsTop {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    [[self getWindow] insertSubview:sView_ atIndex:[self getWindow].subviews.count];
}

    // 添加手势
+ (void)addPanGesture {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    [sView_ addPanGesture];
}

    // 移除手势
+ (void)removeGesture {
    if (!sView_) {
        NSLog(@"不存在view");
        return;
    }
    [sView_ removeGesture];
}

#pragma mark -- 实例方法

// 销毁视图
- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        sView_ = nil;
    }];
}

// 添加手势
- (void)addPanGesture {
    [self addGestureRecognizer:self.panGesture];
}

// 移除手势
- (void)removeGesture {
    [self removeGestureRecognizer:self.panGesture];
}

// 手势响应
- (void)respondsToPan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.originPoint = self.center;
            self.startPoint = [gesture locationInView:[self getWindow]];
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [gesture locationInView:[self getWindow]];
            CGFloat x = self.originPoint.x + point.x - self.startPoint.x;
            CGFloat y = self.originPoint.y + point.y - self.startPoint.y;
            self.center = CGPointMake(x, y);
        }
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            [self goHome];
        }
            break;
            
        default:
            break;
    }
}

// 回家, 边缘就是家 0.0
- (void)goHome {
    CGFloat x = 0 + self.bounds.size.width/2;
    if (self.center.x > XQ_Screen_Width/2) {
        x = XQ_Screen_Width - self.bounds.size.width/2;
    }
    self.center = CGPointMake(x, self.center.y);
}

// 刷新视图
- (void)refreshViewType {
    self.layer.masksToBounds = YES;
    
    // 表示第一次
    if (self.subviews.count == 0) {
        [self addSubview:self.normalView];
        [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    switch (self.beforeType) {
        case XQSuspensionViewTypeRound:{
            [self addView];
            [self.roundView removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        if (self.alpha == 0) {
            self.alpha = 1;
        }
        
        self.layer.cornerRadius = 0;
        CGPoint center = self.center;
        
        switch (self.type) {
            case XQSuspensionViewTypeNormal:{
                self.frame = CGRectMake(0, 0, XQ_Screen_Width, XQ_Screen_Height);
            }
                break;
                
            case XQSuspensionViewTypeRectangle:{
                self.frame = [XQSuspensionViewTool getRectangleRect];
                if (center.y < 0) {
                    self.center = CGPointMake(self.center.x, center.y);
                }
                //self.center = CGPointMake(self.center.x, 0);
            }
                break;
                
            case XQSuspensionViewTypeRound:{
                CGRect rect = [XQSuspensionViewTool getRoundRect];
                self.frame = rect;
                self.layer.cornerRadius = rect.size.width/2;
                self.center = CGPointMake(self.center.x, center.y);
            }
                break;
                
            case XQSuspensionViewTypeHide:{
                self.alpha = 0;
            }
                break;
                
            default:
                break;
        }
        
        
        
    } completion:^(BOOL finished) {
        if (self.type == XQSuspensionViewTypeNormal) {
            [self removeGesture];
        }else {
            [self addPanGesture];
        }
        
        switch (self.beforeType) {
            case XQSuspensionViewTypeNormal:{
                [self.normalView removeFromSuperview];
                [self addView];
            }
                break;
                
            case XQSuspensionViewTypeRectangle:{
                [self.rectangleView removeFromSuperview];
                [self addView];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)addView {
    switch (self.type) {
        case XQSuspensionViewTypeNormal:{
            [self removeGesture];
            [self addSubview:self.normalView];
            [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
            break;
            
        case XQSuspensionViewTypeRectangle:{
            [self addSubview:self.rectangleView];
            [self.rectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
            break;
            
        case XQSuspensionViewTypeRound:{
            [self addSubview:self.roundView];
            [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    NSLog(@"悬浮view释放");
}

- (UIWindow *)getWindow {
    return [[self class] getWindow];
}

+ (UIWindow *)getWindow {
#if !XQExtensionFramework
    return [XQApplication sharedApplication].keyWindow;
#else
    return nil;
#endif
}

#pragma mark -- get

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    }
    return _panGesture;
}

@end
























