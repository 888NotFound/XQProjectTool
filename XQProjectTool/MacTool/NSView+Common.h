//
//  NSView+Common.h
//  MacApp
//
//  Created by WXQ on 2018/8/19.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Common)

+ (instancetype)xq_loadNibWithName:(NSString *)name bundle:(NSBundle *)bundle;

@end
