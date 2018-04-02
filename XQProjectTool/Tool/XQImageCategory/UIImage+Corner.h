//
//  UIImage+Round.h
//  ImgRound
//
//  Created by ladystyle100 on 2017/9/14.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Corner)

/** 用context剪裁, 超过图片的最大角度, 会保持椭圆或圆形 */
+ (UIImage *)contextClip:(UIImage *)img cornerRadius:(CGFloat)radius;
/** 用bezier剪裁, 超过图片最大角度, 会变的奇形怪状 */
+ (UIImage *)bezierPathClip:(UIImage *)img cornerRadius:(CGFloat)radius;

@end
