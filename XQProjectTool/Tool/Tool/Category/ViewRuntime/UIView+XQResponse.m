//
//  UIView+XQResponse.m
//  RuntimeBlock
//
//  Created by ladystyle100 on 2017/9/18.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "UIView+XQResponse.h"
#import <objc/message.h>

/*
UITapGestureRecognizer *tap;// 点击
UILongPressGestureRecognizer *longPress;// 长按
UISwipeGestureRecognizer *swipe;// 轻扫
UIPanGestureRecognizer *pan;// 拖拽
UIPinchGestureRecognizer *pinch;// 捏合
UIRotationGestureRecognizer *rotation;// 旋转
 */


#if TARGET_OS_IPHONE
@implementation UIView (XQResponse)
#else
@implementation NSView (XQResponse)
#endif

#pragma mark -- 添加

#pragma mark -- 直接添加手势
- (void)xq_addGestureWithGesture:(XQGestureRecognizer_class *)gesture callback:(XQGesture)callback {
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 点击
- (void)xq_addTapWithCallback:(XQTap)callback {
    [self xq_addTapWithNumberOfTapsRequired:1 callback:callback];
}

- (void)xq_addTapWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired callback:(XQTap)callback {
    XQTapGestureRecognizer_class *gesture = [XQTapGestureRecognizer_class new];
#if TARGET_OS_IPHONE
    gesture.numberOfTapsRequired = numberOfTapsRequired;
#else
    gesture.numberOfClicksRequired = numberOfTapsRequired;
#endif
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
    XQLongPressGestureRecognizer_class *gesture = [XQLongPressGestureRecognizer_class new];
#if TARGET_OS_IPHONE
    gesture.numberOfTapsRequired = numberOfTapsRequired;
#else
    gesture.numberOfTouchesRequired = numberOfTapsRequired;
#endif
    gesture.minimumPressDuration = minimumPressDuration;
    gesture.allowableMovement = allowableMovement;
    [self setAssociatedWithGesture:gesture callback:callback];
}

#if TARGET_OS_IPHONE
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
#endif

#pragma mark -- 拖拽
- (void)xq_addPanWithCallback:(XQPan)callback {
    XQPanGestureRecognizer_class *gesture = [XQPanGestureRecognizer_class new];
    [self setAssociatedWithGesture:gesture callback:callback];
}

#if TARGET_OS_IPHONE
#pragma mark -- 捏合
- (void)xq_addPinchWithCallback:(XQPinch)callback {
    UIPinchGestureRecognizer *gesture = [UIPinchGestureRecognizer new];
    [self setAssociatedWithGesture:gesture callback:callback];
}
#endif

#pragma mark -- 旋转
- (void)xq_addRotationWithCallback:(XQRotation)callback {
    XQRotationGestureRecognizer_class *gesture = [XQRotationGestureRecognizer_class new];
    [self setAssociatedWithGesture:gesture callback:callback];
}

#pragma mark -- 删除
- (void)xq_removeTap {
    [self xq_removeGestureWithClass:[XQTapGestureRecognizer_class class]];
}

- (void)xq_removeLongPress {
    [self xq_removeGestureWithClass:[XQLongPressGestureRecognizer_class class]];
}

- (void)xq_removePan {
    [self xq_removeGestureWithClass:[XQPanGestureRecognizer_class class]];
}

- (void)xq_removePinch {
#if TARGET_OS_IPHONE
    [self xq_removeGestureWithClass:[UIPinchGestureRecognizer class]];
#endif
}

- (void)xq_removeRotation {
    [self xq_removeGestureWithClass:[XQRotationGestureRecognizer_class class]];
}

- (void)xq_removeGestureWithClass:(Class)class {
    for (XQGestureRecognizer_class *gesture in self.gestureRecognizers) {
        if ([gesture isMemberOfClass:class]) {
            [self xq_removeGesture:gesture];
        }
    }
}

- (void)xq_removeSwipeWithDirection:(XQSwipeDirection)direction {
#if TARGET_OS_IPHONE
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
#endif
}

- (void)xq_removeAllGesture {
    for (XQGestureRecognizer_class *gesture in self.gestureRecognizers) {
        [self xq_removeGesture:gesture];
    }
}

- (void)xq_removeGesture:(XQGestureRecognizer_class *)gesture {
    [self setAssociatedWithGesture:gesture callback:nil];
    [self removeGestureRecognizer:gesture];
}

#pragma mark -- 响应方法
- (void)respondsToGesture:(XQGestureRecognizer_class *)gesture {
    const char * str =  [self getGestureStr:gesture];
    XQGesture click = objc_getAssociatedObject(self, str);
    if (click) {
        click(gesture);
    }else {
        NSLog(@"block不存在");
    }
}

#pragma mark -- 获取关联char
- (const char *)getGestureStr:(XQGestureRecognizer_class *)gesture {
    const char *str = "tap";
    
    if ([gesture isMemberOfClass:[XQTapGestureRecognizer_class class]]) {
        
    }else if ([gesture isMemberOfClass:[XQLongPressGestureRecognizer_class class]]) {
        str = "longPress";
        
#if TARGET_OS_IPHONE
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

        
    }else if ([gesture isMemberOfClass:[UIPinchGestureRecognizer class]]) {
        str = "pinch";
#endif
        
    }else if ([gesture isMemberOfClass:[XQPanGestureRecognizer_class class]]) {
        str = "pan";
    }else if ([gesture isMemberOfClass:[XQRotationGestureRecognizer_class class]]) {
        str = "rotation";
    }
    
    return str;
}

#pragma mark -- 设置关联手势
- (void)setAssociatedWithGesture:(XQGestureRecognizer_class *)gesture callback:(id)callback {
#if TARGET_OS_IPHONE
    [gesture addTarget:self action:@selector(respondsToGesture:)];
#else
    gesture.target = self;
    gesture.action = @selector(respondsToGesture:);
#endif
    
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
















