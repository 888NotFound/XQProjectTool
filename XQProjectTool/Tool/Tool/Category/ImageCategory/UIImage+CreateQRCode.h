//
//  UIImage+CreateQRCode.h
//  QRCode
//
//  Created by ladystyle100 on 2017/4/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if TARGET_OS_IPHONE
#define XQ_D_ImageType UIImage
#else
#define XQ_D_ImageType NSImage
#endif


@interface XQ_D_ImageType (CreateQRCode)

/**
 * data:转为二维码的数据
 * imgSize:图片大小
 */
+ (XQ_D_ImageType *)createQRCodeWithData:(NSData *)data imgSize:(CGFloat)imgSize;

/**
 传入ciimage和size生成图片
 */
+ (XQ_D_ImageType *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

/**
 传入图片, 获取图片的二维码信息
 */
+ (NSArray <NSString *> *)xq_getCodeInfoWithCIImage:(CIImage *)ciImage;

/**
 传入图片, 获取图片的二维码
 
 @return 如有多个, 则返回多个
 */
+ (NSArray <NSString *> *)getCodeInfoWithImg:(XQ_D_ImageType *)img;

/**
 传入图片data, 获取图片的二维码
 
 @return 如有多个, 则返回多个
 */
+ (NSArray <NSString *> *)xq_getCodeInfoWithImageData:(NSData *)imageData;

#if !TARGET_OS_IPHONE
+ (NSData *)xq_imageTransferWithImage:(NSImage *)image isPNG:(BOOL)isPNG;
#endif

@end
