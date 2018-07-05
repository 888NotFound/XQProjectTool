//
//  UIImage+CreateQRCode.h
//  QRCode
//
//  Created by ladystyle100 on 2017/4/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CreateQRCode)

/**
 * data:转为二维码的数据
 * imgSize:图片大小
 */
+ (UIImage *)createQRCodeWithData:(NSData *)data imgSize:(CGFloat)imgSize;

/**
 传入图片, 获取图片的二维码
 
 @return 如有多个, 则返回多个
 */
+ (NSArray <NSString *> *)getCodeInfoWithImg:(UIImage *)img;

@end
