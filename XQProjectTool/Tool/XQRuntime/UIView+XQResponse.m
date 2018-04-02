//
//  UIView+XQResponse.m
//  RuntimeBlock
//
//  Created by ladystyle100 on 2017/9/18.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "UIView+XQResponse.h"
#import <objc/message.h>

@interface UIButton ()

@end

/*
UITapGestureRecognizer *tap;// 点击
UILongPressGestureRecognizer *longPress;// 长按
UISwipeGestureRecognizer *swipe;// 轻扫
UIPanGestureRecognizer *pan;// 拖拽
UIPinchGestureRecognizer *pinch;// 捏合
UIRotationGestureRecognizer *rotation;// 旋转
 */

@implementation UIView (XQResponse)

#pragma mark -- 添加

#pragma mark -- 直接添加手势
- (void)xq_addGestureWithGesture:(UIGestureRecognizer *)gesture callback:(XQGesture)callback {
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 点击
- (void)xq_addTapWithCallback:(XQTap)callback {
    [self xq_addTapWithNumberOfTapsRequired:1 callback:callback];
}

- (void)xq_addTapWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired callback:(XQTap)callback {
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer new];
    gesture.numberOfTapsRequired = numberOfTapsRequired;
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 长按
- (void)xq_addLongPressWithCallback:(XQLongPress)callback {
    [self xq_addLongPressWithNumberOfTapsRequired:0 minimumPressDuration:0.5 allowableMovement:10 callback:callback];
}

- (void)xq_addLongPressWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                           minimumPressDuration:(CFTimeInterval)minimumPressDuration
                              allowableMovement:(CGFloat)allowableMovement
                                       callback:(XQLongPress)callback {
    UILongPressGestureRecognizer *gesture = [UILongPressGestureRecognizer new];
    gesture.numberOfTapsRequired = numberOfTapsRequired;
    gesture.minimumPressDuration = minimumPressDuration;
    gesture.allowableMovement = allowableMovement;
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 轻扫
- (void)xq_addSwipeWithDirection:(XQSwipeDirection)direction callback:(XQSwipe)callback {
    if (direction == XQSwipeDirectionAll) {
        NSArray *arr = @[@(UISwipeGestureRecognizerDirectionUp), @(UISwipeGestureRecognizerDirectionDown), @(UISwipeGestureRecognizerDirectionRight), @(UISwipeGestureRecognizerDirectionLeft)];
        for (NSNumber *direction in arr) {
            UISwipeGestureRecognizer *gesture = [UISwipeGestureRecognizer new];
            gesture.direction = (UISwipeGestureRecognizerDirection)direction.unsignedIntegerValue;
            [self setAssociatedWithGesture:gesture callback:callback];
        }
        return;
    }
    
    UISwipeGestureRecognizer *gesture = [UISwipeGestureRecognizer new];
    gesture.direction = (UISwipeGestureRecognizerDirection)direction;
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 拖拽
- (void)xq_addPanWithCallback:(XQPan)callback {
    UIPanGestureRecognizer *gesture = [UIPanGestureRecognizer new];
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 捏合
- (void)xq_addPinchWithCallback:(XQPinch)callback {
    UIPinchGestureRecognizer *gesture = [UIPinchGestureRecognizer new];
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 旋转
- (void)xq_addRotationWithCallback:(XQRotation)callback {
    UIRotationGestureRecognizer *gesture = [UIRotationGestureRecognizer new];
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 删除
- (void)xq_removeTap {
    [self xq_removeGestureWithClass:[UITapGestureRecognizer class]];
}

- (void)xq_removeLongPress {
    [self xq_removeGestureWithClass:[UILongPressGestureRecognizer class]];
}

- (void)xq_removePan {
    [self xq_removeGestureWithClass:[UIPanGestureRecognizer class]];
}

- (void)xq_removePinch {
    [self xq_removeGestureWithClass:[UIPinchGestureRecognizer class]];
}

- (void)xq_removeRotation {
    [self xq_removeGestureWithClass:[UIRotationGestureRecognizer class]];
}

- (void)xq_removeGestureWithClass:(Class)class {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isMemberOfClass:class]) {
            [self xq_removeGesture:gesture];
        }
    }
}

- (void)xq_removeSwipeWithDirection:(XQSwipeDirection)direction {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isMemberOfClass:[UISwipeGestureRecognizer class]]) {
            
            if (direction == XQSwipeDirectionAll) {
                [self xq_removeGesture:gesture];
                continue;
            }
            
            UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gesture;
            if (swipe.direction == (UISwipeGestureRecognizerDirection)direction) {
                [self xq_removeGesture:gesture];
            }
            
        }
    }
}

- (void)xq_removeAllGesture {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self xq_removeGesture:gesture];
    }
}

- (void)xq_removeGesture:(UIGestureRecognizer *)gesture {
    [self setAssociatedWithGesture:gesture callback:nil];
    [self removeGestureRecognizer:gesture];
}

#pragma mark -- 响应方法
- (void)respondsToGesture:(UIGestureRecognizer *)gesture {
    const char * str =  [self getGestureStr:gesture];
    XQGesture click = objc_getAssociatedObject(self, str);
    if (click) {
        click(gesture);
    }else {
        NSLog(@"block不存在");
    }
}

#pragma mark -- 获取关联char
- (const char *)getGestureStr:(UIGestureRecognizer *)gesture {
    const char *str = "tap";
    
    if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
        
    }else if ([gesture isMemberOfClass:[UILongPressGestureRecognizer class]]) {
        str = "longPress";
    }else if ([gesture isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gesture;
        switch (swipe.direction) {
            case UISwipeGestureRecognizerDirectionUp:
                str = "swipeUp";
                break;
                
            case UISwipeGestureRecognizerDirectionDown:
                str = "swipeDown";
                break;
                
            case UISwipeGestureRecognizerDirectionRight:
                str = "swipeRight";
                break;
                
            case UISwipeGestureRecognizerDirectionLeft:
                str = "swipeLeft";
                break;
                
            default:
                str = "swipeUp";
                break;
        }
        
    }else if ([gesture isMemberOfClass:[UIPanGestureRecognizer class]]) {
        str = "pan";
    }else if ([gesture isMemberOfClass:[UIPinchGestureRecognizer class]]) {
        str = "pinch";
    }else if ([gesture isMemberOfClass:[UIRotationGestureRecognizer class]]) {
        str = "rotation";
    }
    
    return str;
}

#pragma mark -- 设置关联手势
- (void)setAssociatedWithGesture:(UIGestureRecognizer *)gesture callback:(id)callback {
    [gesture addTarget:self action:@selector(respondsToGesture:)];
    [self addGestureRecognizer:gesture];
    const char * str =  [self getGestureStr:gesture];
    objc_setAssociatedObject(self, str, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- dealloc删除关联
//- (void)dealloc {
//    //NSLog(@"%s, self = %@", __func__, self);
//    NSLog(@"%s", __func__);
//    objc_removeAssociatedObjects(self);
//}

@end
















