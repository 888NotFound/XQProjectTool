//
//  UIView+XQResponse.h
//  RuntimeBlock
//
//  Created by ladystyle100 on 2017/9/18.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQGesture)(UIGestureRecognizer *gesture);
typedef void(^XQTap)(UITapGestureRecognizer *gesture);
typedef void(^XQLongPress)(UILongPressGestureRecognizer *gesture);
typedef void(^XQSwipe)(UISwipeGestureRecognizer *gesture);
typedef void(^XQPan)(UIPanGestureRecognizer *gesture);
typedef void(^XQPinch)(UIPinchGestureRecognizer *gesture);
typedef void(^XQRotation)(UIRotationGestureRecognizer *gesture);

typedef NS_OPTIONS(NSUInteger, XQSwipeDirection) {
    XQSwipeDirectionRight = 1 << 0,
    XQSwipeDirectionLeft  = 1 << 1,
    XQSwipeDirectionUp    = 1 << 2,
    XQSwipeDirectionDown  = 1 << 3,
    XQSwipeDirectionAll  = 1 << 4 // 添加或删除所有方向手势
};

@interface UIView (XQResponse)


- (void)xq_addGestureWithGesture:(UIGestureRecognizer *)gesture
                        callback:(XQGesture)callback;

- (void)xq_addTapWithCallback:(XQTap)callback;
- (void)xq_addTapWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                 callback:(XQTap)callback;

- (void)xq_addLongPressWithCallback:(XQLongPress)callback;
- (void)xq_addLongPressWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                           minimumPressDuration:(CFTimeInterval)minimumPressDuration
                              allowableMovement:(CGFloat)allowableMovement
                                       callback:(XQLongPress)callback;

- (void)xq_addSwipeWithDirection:(XQSwipeDirection)direction
                        callback:(XQSwipe)callback;

- (void)xq_addPanWithCallback:(XQPan)callback;

- (void)xq_addPinchWithCallback:(XQPinch)callback;

- (void)xq_addRotationWithCallback:(XQRotation)callback;


/**** 删除 ***/
- (void)xq_removeAllGesture;
- (void)xq_removeGesture:(UIGestureRecognizer *)gesture;
- (void)xq_removeTap;
- (void)xq_removeLongPress;
- (void)xq_removeSwipeWithDirection:(XQSwipeDirection)direction;
- (void)xq_removePan;
- (void)xq_removePinch;
- (void)xq_removeRotation;

@end












