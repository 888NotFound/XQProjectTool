//
//  UIImage+SubImage.h
//  UIImage+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SubImage)

/** 截取当前image对象rect区域内的图像 */
- (nullable UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (nullable UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (nullable UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (nullable UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (nullable UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
+ (nullable UIImage *)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/// 合并图片
/// @param imgArr 要合并的图片
/// @param direction 0 垂直, 1 横向
+ (nullable UIImage *)xq_composeWithImgArr:(NSArray <UIImage *> *)imgArr direction:(NSInteger)direction;

@end

NS_ASSUME_NONNULL_END
