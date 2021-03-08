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

- (XQ_Image_type *)xq_imageWithTintColor:(XQ_Color_Type *)tintColor {
#if TARGET_OS_IPHONE
    
    if (@available(iOS 13.0, *)) {
        // wxq 系统自己出了方法
        return [self imageWithTintColor:tintColor];
    } else {
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
    }
    
    return nil;
    
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


/// 判断图片亮暗
/// @return YES 亮，NO 暗
+ (BOOL)xq_imageIsLightWithImage:(UIImage *)image {
    return [self xq_imageIsLightWithImage:image pixel:2 average:600];
}

/// 判断图片亮暗
/// @param pixel 遍历跳过的像素, 1就是没跳过，2就是跳一个，一般 2 ~ 4 就行了
/// @param average 超过哪个平均值算亮
/// @return YES 亮，NO 暗
+ (BOOL)xq_imageIsLightWithImage:(UIImage *)image pixel:(int)pixel average:(int)average {
    if (!image) {
        NSLog(@"图片不存在");
        return YES;
    }
    
    __block int count = 0;
    __block long int total = 0;
    CGFloat w = image.size.width;
    [self getImageDataWithImage:image callback:^(unsigned char *data) {
        
        for (int x = 0; x < image.size.width; x += pixel) {
            
            for (int y = 0; y < image.size.height; y += pixel) {
                
                int offset = 4 * ((w * round(y)) + round(x));
                int alpha =  data[offset];
                int red = data[offset+1];
                int green = data[offset+2];
                int blue = data[offset+3];
                
                if (alpha == 0) {
                    // 完全透明, 忽略
                    return;
                }
                
                // 判断亮暗
//                BOOL is = YES;
                int num = red + green + blue;
//                if (num < 382) {
//                if (num < 550) {
//                    is = NO;
//                }
                
                total += num;
                count++;
                
            }
            
        }
        
    }];
    
//    return light > dark;
    long int currentAverage = total/count;
    return currentAverage > average;
}

///// 根据图片获取图片的主色调
//+ (nullable UIColor *)xq_getImageMainColorWithImage:(UIImage *)image {
//    if (!image) {
//        return nil;
//    }
//
//    CGSize size = image.size;
//    int w = image.size.width;
//
//    __block NSArray *maxColor = nil;
//
//    NSLog(@"解析图片");
//
//    [self getImageDataWithImage:image callback:^(unsigned char *data) {
//        NSLog(@"遍历像素点");
//        // 第二步 取每个点的像素值
//        NSCountedSet *cls = [NSCountedSet setWithCapacity:size.width * size.height];
//
//        for (int x = 0; x < size.width; x += 2) {
//            for (int y = 0; y< size.height; y += 2) {
//    //            int offset = 4*(x*y);
//    //            int red = data[offset];
//    //            int green = data[offset+1];
//    //            int blue = data[offset+2];
//    //            int alpha =  data[offset+3];
//
//                int offset = 4 * ((w * round(y)) + round(x));
//                int alpha =  data[offset];
//                int red = data[offset+1];
//                int green = data[offset+2];
//                int blue = data[offset+3];
//
//                if (alpha <= 0) {
//                    // 去除透明
//                    continue;
//                }
//
//                NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
//                [cls addObject:clr];
//            }
//        }
//
//        NSLog(@"找颜色最多");
//
//        //第三步 找到出现次数最多的那个颜色
//        NSEnumerator *enumerator = [cls objectEnumerator];
//        NSArray *curColor = nil;
//
//        NSUInteger MaxCount = 0;
//        while ( (curColor = [enumerator nextObject]) != nil ) {
//            NSUInteger tmpCount = [cls countForObject:curColor];
//            if ( tmpCount < MaxCount ) {
//                continue;
//            }
//            MaxCount = tmpCount;
//            maxColor = curColor;
//        }
//    }];
//
//    if (!maxColor) {
//        return nil;
//    }
//
//    NSLog(@"结果: %@", maxColor);
//
//    return [UIColor colorWithRed:([maxColor[0] intValue]/255.0f) green:([maxColor[1] intValue]/255.0f) blue:([maxColor[2] intValue]/255.0f) alpha:([maxColor[3] intValue]/255.0f)];
//}

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

/// 根据图片获取图片的主色调
+ (UIColor *)xq_getImageMainColorWithImage:(UIImage *)image {
    
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        
    }
    
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}



/// 获取图片的 data
+ (void)getImageDataWithImage:(UIImage *)image callback:(void(^)(unsigned char* data))callback {
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    
    if (cgctx == NULL) {
        return;
    }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    
    if (data != NULL) {
        if (callback) {
            callback(data);
        }
        
        if (data) {
            free(data);
        }
    }
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef) inImage {

    CGContextRef    context = NULL;

    CGColorSpaceRef colorSpace;

    void *          bitmapData;

    int             bitmapByteCount;

    int             bitmapBytesPerRow;

    size_t pixelsWide = CGImageGetWidth(inImage);

    size_t pixelsHigh = CGImageGetHeight(inImage);

    bitmapBytesPerRow   = (int)(pixelsWide * 4);

    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);

    colorSpace = CGColorSpaceCreateDeviceRGB();

    if (colorSpace == NULL)

    {

        fprintf(stderr, "Error allocating color space\n");

        return NULL;

    }

    bitmapData = malloc( bitmapByteCount );

    if (bitmapData == NULL)

    {

        fprintf (stderr, "Memory not allocated!");

        CGColorSpaceRelease( colorSpace );

        return NULL;

    }

    context = CGBitmapContextCreate (bitmapData,

                                     pixelsWide,

                                     pixelsHigh,

                                     8,

                                     bitmapBytesPerRow,

                                     colorSpace,

                                     kCGImageAlphaPremultipliedFirst);

    if (context == NULL)

    {

        free (bitmapData);

        fprintf (stderr, "Context not created!");

    }

    CGColorSpaceRelease( colorSpace );

    return context;

}

@end
