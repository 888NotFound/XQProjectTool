//
//  NSImage+ColorTools.h
//  Brainpeek
//
//  Created by Eugene Braginets on 8/2/16.
//  Copyright © 2016 Eugene Braginets. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (ColorTools)

// warning: doesn't for the greyscale colorspace! rgb components are expected
-(NSImage*) replaceColor:(NSColor*)inputColor withColor:(NSColor*)resultColor;

// warning: doesn't for the greyscale colorspace! rgb components are expected
-(NSImage*) replaceColor:(NSColor*)inputColor withColor:(NSColor*)resultColor withThreshold:(float)threshold;


/**
 填充图片颜色
 */
- (NSImage*)xq_fullColorwithColor:(NSColor*)resultColor;

@end
