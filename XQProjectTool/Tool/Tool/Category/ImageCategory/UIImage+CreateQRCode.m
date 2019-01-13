//
//  UIImage+CreateQRCode.m
//  QRCode
//
//  Created by ladystyle100 on 2017/4/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "UIImage+CreateQRCode.h"
#import <CoreImage/CoreImage.h>

@implementation XQ_D_ImageType (CreateQRCode)

/**
 data:转为二维码的数据
 imgSize:图片大小
 */
+ (XQ_D_ImageType *)createQRCodeWithData:(NSData *)data imgSize:(CGFloat)imgSize {
    // 创建滤镜
    // CIQRCodeGenerator:这个是固定的，生产二维码的意思
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 还原滤镜
    [filter setDefaults];
    // 设置数据，inputMessage:这个是固定的，输入数据
    [filter setValue:data forKey:@"inputMessage"];
    // 取出滤镜图片ci
    CIImage *imgCI = filter.outputImage;
    // 把ci转成图片
    return [self createNonInterpolatedUIImageFormCIImage:imgCI withSize:imgSize];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (XQ_D_ImageType *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
#if TARGET_OS_IPHONE
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
#else
    NSImage *img = [[NSImage alloc] initWithCGImage:scaledImage size:NSMakeSize(size, size)];
#endif
    CGImageRelease(scaledImage);
    
    return img;
}

+ (NSArray <NSString *> *)getCodeInfoWithImg:(XQ_D_ImageType *)img {
    if (!img) {
        return @[];
    }
#if TARGET_OS_IPHONE
    NSData *imageData = UIImagePNGRepresentation(img);
#else
    NSData *imageData = [self xq_imageTransferWithImage:img isPNG:YES];
#endif
    
    return [self xq_getCodeInfoWithImageData:imageData];
}

+ (NSArray <NSString *> *)xq_getCodeInfoWithImageData:(NSData *)imageData {
    if (!imageData) {
        return @[];
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *ciImage = [CIImage imageWithData:imageData];
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count == 0) {
        return @[];
    }
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (CIQRCodeFeature *qrFeature in features) {
        [muArr addObject:qrFeature.messageString];
    }
    return muArr.copy;
}

#if !TARGET_OS_IPHONE
+ (NSData *)xq_imageTransferWithImage:(NSImage *)image isPNG:(BOOL)isPNG {
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    [imageRep setSize:[image size]];
    
    if (isPNG) {
        // png
        return [imageRep representationUsingType:NSPNGFileType properties:nil];
    }
    
    // jpg
    NSDictionary *imageProps = nil;
    NSNumber *quality = [NSNumber numberWithFloat:.85];
    imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
    return [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
}
#endif

@end






