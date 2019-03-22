//
//  XQTextField.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/22.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQTextField.h"

@implementation XQTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)textShouldBeginEditing:(NSText *)textObject {
    if ([self.xq_delegate respondsToSelector:@selector(textField:textShouldBeginEditing:)]) {
        return [self.xq_delegate textField:self textShouldBeginEditing:textObject];
    }
    return [super textShouldBeginEditing:textObject];
}

- (BOOL)textShouldEndEditing:(NSText *)textObject {
    if ([self.xq_delegate respondsToSelector:@selector(textField:textShouldEndEditing:)]) {
        return [self.xq_delegate textField:self textShouldEndEditing:textObject];
    }
    return [super textShouldEndEditing:textObject];
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    [super textDidBeginEditing:notification];
    [self.xq_delegate textField:self textDidBeginEditing:notification];
}

- (void)textDidEndEditing:(NSNotification *)notification {
    [super textDidEndEditing:notification];
    [self.xq_delegate textField:self textDidEndEditing:notification];
}

- (void)textDidChange:(NSNotification *)notification {
    [super textDidChange:notification];
    [self.xq_delegate textField:self textDidChange:notification];
}


@end
