//
//  UIButton+XQResponse.h
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XQButtonClick)(UIButton *sender);

@interface UIButton (XQResponse)

#if TARGET_OS_IPHONE
/** 现在只支持 touchUpInside */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQButtonClick)callback;
#endif

@end


typedef void(^XQSliderClick)(UISlider *sender);

@interface UISlider (XQResponse)

#if TARGET_OS_IPHONE
/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSliderClick)callback;
#endif

@end


typedef void(^XQSwitchClick)(UISwitch *sender);

@interface UISwitch (XQResponse)

#if TARGET_OS_IPHONE
/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSwitchClick)callback;
#endif

@end


NS_ASSUME_NONNULL_END
