//
//  UIButton+XQResponse.h
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XQButtonClick)(UIButton *sender);

@interface UIButton (XQResponse)


/** 现在只支持 touchUpInside */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQButtonClick)callback;

@end


typedef void(^XQSliderClick)(UISlider *sender);

@interface UISlider (XQResponse)

/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSliderClick)callback;

@end


typedef void(^XQSwitchClick)(UISwitch *sender);

@interface UISwitch (XQResponse)

/** 现在只支持UIControlEventValueChanged */
- (void)xq_addEvent:(UIControlEvents)event callback:(XQSwitchClick)callback;

@end


NS_ASSUME_NONNULL_END


#endif
