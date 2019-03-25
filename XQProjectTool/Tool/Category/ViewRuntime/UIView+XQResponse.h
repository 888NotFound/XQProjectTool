//
//  UIView+XQResponse.h
//  RuntimeBlock
//
//  Created by ladystyle100 on 2017/9/18.
//  Copyright © 2017年 WangXQ. All rights reserved.
//



#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

#define XQGestureRecognizer_class UIGestureRecognizer
#define XQTapGestureRecognizer_class UITapGestureRecognizer
#define XQLongPressGestureRecognizer_class UILongPressGestureRecognizer
#define XQPanGestureRecognizer_class UIPanGestureRecognizer
#define XQRotationGestureRecognizer_class UIRotationGestureRecognizer

#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>

#define XQGestureRecognizer_class NSGestureRecognizer
#define XQTapGestureRecognizer_class NSClickGestureRecognizer
#define XQLongPressGestureRecognizer_class NSPressGestureRecognizer
#define XQPanGestureRecognizer_class NSPanGestureRecognizer
#define XQRotationGestureRecognizer_class NSRotationGestureRecognizer

#endif


#if TARGET_OS_IPHONE
typedef void(^XQSwipe)(UISwipeGestureRecognizer *gesture);
typedef void(^XQPinch)(UIPinchGestureRecognizer *gesture);
#endif
typedef void(^XQGesture)(XQGestureRecognizer_class *gesture);
typedef void(^XQTap)(XQTapGestureRecognizer_class *gesture);
typedef void(^XQLongPress)(XQLongPressGestureRecognizer_class *gesture);
typedef void(^XQPan)(XQPanGestureRecognizer_class *gesture);
typedef void(^XQRotation)(XQRotationGestureRecognizer_class *gesture);



typedef NS_OPTIONS(NSUInteger, XQSwipeDirection) {
    XQSwipeDirectionRight = 1 << 0,
    XQSwipeDirectionLeft  = 1 << 1,
    XQSwipeDirectionUp    = 1 << 2,
    XQSwipeDirectionDown  = 1 << 3,
    XQSwipeDirectionAll  = 1 << 4 // 添加或删除所有方向手势
};


#if TARGET_OS_IPHONE
@interface UIView (XQResponse)
#else
@interface NSView (XQResponse)
#endif

- (void)xq_addGestureWithGesture:(XQGestureRecognizer_class *)gesture
                        callback:(XQGesture)callback;

- (void)xq_addTapWithCallback:(XQTap)callback;
- (void)xq_addTapWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                 callback:(XQTap)callback;

- (void)xq_addLongPressWithCallback:(XQLongPress)callback;
- (void)xq_addLongPressWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                           minimumPressDuration:(CFTimeInterval)minimumPressDuration
                              allowableMovement:(CGFloat)allowableMovement
                                       callback:(XQLongPress)callback;

#if TARGET_OS_IPHONE
- (void)xq_addSwipeWithDirection:(XQSwipeDirection)direction
                        callback:(XQSwipe)callback;
#endif

- (void)xq_addPanWithCallback:(XQPan)callback;

#if TARGET_OS_IPHONE
- (void)xq_addPinchWithCallback:(XQPinch)callback;
#endif

- (void)xq_addRotationWithCallback:(XQRotation)callback;


/**** 删除 ***/
- (void)xq_removeAllGesture;
- (void)xq_removeGesture:(XQGestureRecognizer_class *)gesture;
- (void)xq_removeTap;
- (void)xq_removeLongPress;
- (void)xq_removeSwipeWithDirection:(XQSwipeDirection)direction;
- (void)xq_removePan;
- (void)xq_removePinch;
- (void)xq_removeRotation;

@end












