//
//  UIImage+CreateQRCode.m
//  QRCode
//
//  Created by ladystyle100 on 2017/4/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "UIImage+CreateQRCode.h"

@implementation UIImage (CreateQRCode)

/**
 data:转为二维码的数据
 imgSize:图片大小
 */
+ (UIImage *)createQRCodeWithData:(NSData *)data imgSize:(CGFloat)imgSize {
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
    return [UIImage createNonInterpolatedUIImageFormCIImage:imgCI withSize:imgSize];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
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
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return img;
}

+ (NSArray <NSString *> *)getCodeInfoWithImg:(UIImage *)img {
    if (!img) {
        return @[];
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSData *imageData = UIImagePNGRepresentation(img);
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

@end






