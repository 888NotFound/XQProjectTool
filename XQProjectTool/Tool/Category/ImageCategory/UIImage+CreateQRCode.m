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
    // png
#if TARGET_OS_IPHONE
//    NSData *imageData = UIImagePNGRepresentation(img);
    // jpg
    //        NSData *imageData = UIImageJPEGRepresentation(img, 1);
#else
//    NSData *imageData = [self xq_imageTransferWithImage:img isPNG:YES];
//    NSData *imageData = [self xq_imageTransferWithImage:img isPNG:NO];
#endif
    
//    NSArray *arr = [self xq_getCodeInfoWithImageData:imageData];
    
#if TARGET_OS_IPHONE
    NSArray *arr = [self xq_getCodeInfoWithCIImage:[CIImage imageWithCGImage:img.CGImage]];
    
    if (arr.count == 0) {
        // 裁剪图片， 分开解析
        NSArray *imgArr = [self xq_cropImgArrWithImg:img];
        for (UIImage *img in imgArr) {
            NSArray *infoArr = [UIImage xq_getCodeInfoWithCIImage:img.CIImage];
            if (infoArr.count != 0) {
                // 这样的话， 识别一个二维码就直接返回了, 没能识别多个二维码
                arr = infoArr;
                break;
            }
        }
    }
    
    return arr;
#else
    return @[];
#endif
}

+ (void)xq_getCodeInfoWithImg:(XQ_D_ImageType *)img callback:(void(^)(NSArray *qrCodeInfoArr))callback {
#if TARGET_OS_IPHONE
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSArray *arr = [self xq_getCodeInfoWithCIImage:[CIImage imageWithCGImage:img.CGImage]];
        
        if (arr.count == 0) {
            // 裁剪图片， 分开解析
            NSArray *imgArr = [self xq_cropImgArrWithImg:img];
            for (UIImage *cImg in imgArr) {
                NSArray *infoArr = [UIImage xq_getCodeInfoWithCIImage:[CIImage imageWithCGImage:cImg.CGImage]];
                if (infoArr.count != 0) {
                    // 这样的话， 识别一个二维码就直接返回了, 没能识别多个二维码
                    arr = infoArr;
                    break;
                }
            }
        }
        
        if (callback) {
            callback(arr);
        }
    });
#endif
}

+ (NSArray <NSString *> *)xq_getCodeInfoWithImageData:(NSData *)imageData {
    if (!imageData) {
        return @[];
    }
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    return [self xq_getCodeInfoWithCIImage:ciImage];
}

+ (NSArray <NSString *> *)xq_getCodeInfoWithCIImage:(CIImage *)ciImage {
    if (!ciImage) {
        return @[];
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
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

+ (NSArray <XQ_D_ImageType *> *)xq_cropImgArrWithImg:(XQ_D_ImageType *)img {
    if (!img) {
        return @[];
    }
    NSMutableArray *muArr = [NSMutableArray array];
    // 上下
#if TARGET_OS_IPHONE
    [muArr addObject:[XQ_D_ImageType imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, img.size.width, img.size.height/2))]];
    [muArr addObject:[XQ_D_ImageType imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, img.size.height/2, img.size.width, img.size.height/2))]];
    
    // 中间
    [muArr addObject:[XQ_D_ImageType imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(img.size.width/4, img.size.height/4, img.size.width/2, img.size.height/2))]];
    
    // 平铺
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:2]];
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:4]];
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:6]];
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:8]];
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:9]];
    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:12]];
    //    [muArr addObjectsFromArray:[self xq_cropImgArrWithImg:img count:15]];
#endif
    
    return muArr;
}

+ (NSArray <XQ_D_ImageType *> *)xq_cropImgArrWithImg:(XQ_D_ImageType *)img count:(NSUInteger)count {
    if (!img || count == 0 || count == 1) {
        return @[img];
    }
    
    NSMutableArray *muArr = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    CGFloat width = img.size.width/count;
    CGFloat height = img.size.height/count;
    for (int i = 0; i < count; i++) {
        NSUInteger index = i % count;
        [muArr addObject:[XQ_D_ImageType imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(index * width, index * height, width, height))]];
    }
#endif
    
    return muArr;
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






