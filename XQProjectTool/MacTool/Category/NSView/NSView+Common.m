//
//  NSView+Common.m
//  MacApp
//
//  Created by WXQ on 2018/8/19.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import "NSView+Common.h"

@implementation NSView (Common)

+ (instancetype)xq_loadNibWithName:(NSString *)name bundle:(NSBundle *)bundle {
    NSView *view = nil;
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:name bundle:bundle];
    NSArray *arr = [NSArray array];
    if ([nib instantiateWithOwner:self topLevelObjects:&arr]) {
        for (id aView in arr) {
            if ([aView isKindOfClass:NSClassFromString(name)]) {
                view = aView;
                break;
            }
        }
    }
    
    return view;
}

@end
