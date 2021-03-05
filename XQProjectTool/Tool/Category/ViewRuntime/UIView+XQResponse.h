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


NS_ASSUME_NONNULL_BEGIN

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

/**
 添加手势

 @param gesture 需要添加的手势
 @param callback 手势点击回调, 一下都一样, 这个就不写了 ( 就是懒 ~.~ )
 */
- (void)xq_addGestureWithGesture:(XQGestureRecognizer_class *)gesture
                        callback:(XQGesture)callback;

/**
 添加点击手势
 */
- (void)xq_addTapWithCallback:(XQTap)callback;

/**
 添加点击手势

 @param numberOfTapsRequired 点击次数
 */
- (void)xq_addTapWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                 callback:(XQTap)callback;

/**
 添加长按手势
 */
- (void)xq_addLongPressWithCallback:(XQLongPress)callback;

/**
 添加长按手势

 @param numberOfTapsRequired 点击次数
 @param minimumPressDuration 最少长按时间, 单位 s
 @param allowableMovement 允许移动大小
 */
- (void)xq_addLongPressWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                           minimumPressDuration:(CFTimeInterval)minimumPressDuration
                              allowableMovement:(CGFloat)allowableMovement
                                       callback:(XQLongPress)callback;

#if TARGET_OS_IPHONE

/**
 添加轻扫手势

 @param direction 添加的方向
 */
- (void)xq_addSwipeWithDirection:(XQSwipeDirection)direction
                        callback:(XQSwipe)callback;
#endif

/**
 添加拖动手势
 */
- (void)xq_addPanWithCallback:(XQPan)callback;

#if TARGET_OS_IPHONE

/**
 添加捏合手势
 */
- (void)xq_addPinchWithCallback:(XQPinch)callback;
#endif

/**
 添加旋转手势
 */
- (void)xq_addRotationWithCallback:(XQRotation)callback;


/**** 删除 ***/

/**
 移除所有手势
 */
- (void)xq_removeAllGesture;

/**
 移除某个 gesture

 @param gesture 移除对象
 */
- (void)xq_removeGesture:(XQGestureRecognizer_class *)gesture;

/**
 移除 tag gesture
 */
- (void)xq_removeTap;


/**
 移除 long press gesture
 */
- (void)xq_removeLongPress;

/**
 移除 swipe gesture

 @param direction 移除具体方向
 */
- (void)xq_removeSwipeWithDirection:(XQSwipeDirection)direction;

/**
 移除 pan gesture
 */
- (void)xq_removePan;

/**
 移除 pinch gesture
 */
- (void)xq_removePinch;


/**
 移除 rotation gesture
 */
- (void)xq_removeRotation;

@end

NS_ASSUME_NONNULL_END











