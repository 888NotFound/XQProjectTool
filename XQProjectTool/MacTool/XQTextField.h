//
//  XQTextField.h
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/22.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XQTextField;

@protocol XQTextFieldDelegate <NSObject>

- (BOOL)textField:(XQTextField *)textField textShouldBeginEditing:(NSText *)textObject;
- (BOOL)textField:(XQTextField *)textField textShouldEndEditing:(NSText *)textObject;
- (void)textField:(XQTextField *)textField textDidBeginEditing:(NSNotification *)notification;
- (void)textField:(XQTextField *)textField textDidEndEditing:(NSNotification *)notification;
- (void)textField:(XQTextField *)textField textDidChange:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XQTextField : NSTextField

/** 因为系统不自带这个...这边就自己写了 */
@property (nonatomic, weak) id <XQTextFieldDelegate> xq_delegate;

@end

NS_ASSUME_NONNULL_END
