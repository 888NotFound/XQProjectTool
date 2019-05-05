//
//  XQ_Image_type+Color.m
//  XQ_Image_type+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "UIImage+Color.h"

@implementation XQ_Image_type (Color)

/** 根据颜色生成纯色图片 */
+ (XQ_Image_type *)imageWithColor:(XQ_Color_Type *)color {
#if TARGET_OS_IPHONE
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    XQ_Image_type *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
#else
    return nil;
#endif
}

- (XQ_Image_type *)imageWithTintColor:(XQ_Color_Type *)tintColor {
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
//    contentTintColor
    XQ_Image_type *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
#else
    
    return self;
#endif
}

/** 取图片某一像素的颜色 */
- (XQ_Color_Type *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
#if TARGET_OS_IPHONE
    CGImageRef cgImage = self.CGImage;
#else
    NSRect rect = NSMakeRect(0, 0, [self size].width, [self size].height);
    CGImageRef cgImage = [self CGImageForProposedRect:&rect context:nil hints:nil];
#endif
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [XQ_Color_Type colorWithRed:red green:green blue:blue alpha:alpha];
}

/** 获得灰度图 */
- (XQ_Image_type *)convertToGrayImage {
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }

#if TARGET_OS_IPHONE
    CGImageRef cgImage = self.CGImage;
#else
    NSRect rect = NSMakeRect(0, 0, [self size].width, [self size].height);
    CGImageRef cgImage = [self CGImageForProposedRect:&rect context:nil hints:nil];
#endif
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), cgImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    
#if TARGET_OS_IPHONE
    XQ_Image_type *grayImage = [XQ_Image_type imageWithCGImage:contextRef];
#else
    XQ_Image_type *grayImage = [[XQ_Image_type alloc] initWithCGImage:contextRef size:NSMakeSize(width, height)];
#endif
    
    
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

//#if !TARGET_OS_IPHONE
//// 获取像素点颜色
//- (void)colorAtPixel {
//    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
//    NSSize imageSize = [self size];
//    CGFloat y = imageSize.height - 100.0;
//    NSColor* color = [imageRep colorAtX:100.0 y:y];
//    [imageRep release];
//    return;
//}
//#endif



@end
