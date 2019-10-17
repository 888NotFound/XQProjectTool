//
//  UIView+XQLine.h
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 设置边线

 - XQUIViewBorderDirectionTop: 上
 - XQUIViewBorderDirectionBottom: 下
 - XQUIViewBorderDirectionLeft: 左
 - XQUIViewBorderDirectionRight: 右
 */
typedef NS_OPTIONS(NSUInteger, XQUIViewBorderDirection) {
    XQUIViewBorderDirectionTop = 1 << 0,
    XQUIViewBorderDirectionBottom = 1 << 1,
    XQUIViewBorderDirectionLeft = 1 << 2,
    XQUIViewBorderDirectionRight = 1 << 3,
};

@interface UIView (XQLine)

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView
                          lineLength:(int)lineLength
                         lineSpacing:(int)lineSpacing
                           lineColor:(UIColor *)lineColor
                       lineDirection:(BOOL)isHorizonal;

/**
 视图边界线, 这里是用layer的方式, 跟随 frame 大小
 需要注意的是, 如果传进来的view, frame是0, 那么画图也是0

 @param view 需要添加layer的视图
 @param top YES画, NO不画
 @param color 线颜色
 */
+ (void)setBorderWithView:(UIView *)view
                      top:(BOOL)top
                     left:(BOOL)left
                   bottom:(BOOL)bottom
                    right:(BOOL)right
              borderColor:(UIColor *)color
              borderWidth:(CGFloat)width;

/**
 视图边界线, 这里是用layer的方式, 跟随 frame 大小
 
 @param view 需要添加layer的视图
 @param direction 上下左右, 可多选
 @param color 线颜色
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width;

/**
 视图边界线, 这里是用layer的方式, 跟随 frame 大小
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param footSpacing 线, 距离尾部距离
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 headSpacing:(CGFloat)headSpacing
                 footSpacing:(CGFloat)footSpacing
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width;

/**
 视图边界线, 这里是用layer的方式, 自定义线宽度
 
 @note 但是这个, 又随即而来了一个问题, 就是在 frame 是 0 的情况下, 添加不了 bottom 和 right, 因为当时获取的 y 和 x 都是0
 所以这个方法只能用在 top 和 left 上
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param lineWidth 线的长度, 自定义长度, 而不是跟着view当前的size来
 */
//+ (void)xq_setBorderWithView:(UIView *)view
//                   direction:(XQUIViewBorderDirection)direction
//                 headSpacing:(CGFloat)headSpacing
//                   lineWidth:(CGFloat)lineWidth
//                 borderColor:(UIColor *)color
//                 borderWidth:(CGFloat)width;

/**
 视图边界线, 这里是用layer的方式, 自定义线宽度
 
 @note 这样是完美了, 但却是过于麻烦, 填的参数过多
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param lineWidth 线的长度, 自定义长度, 而不是跟着view当前的size来
 @param y 如果是 .bottom 那么就是 y, 如果是 .right 那么就是 x
 
 @note 如果设置 top 和 left , 那么 y = 0 就可以, 0 就忽略这个属性
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 headSpacing:(CGFloat)headSpacing
                   lineWidth:(CGFloat)lineWidth
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width
                           y:(CGFloat)y;

#pragma mark - 设置部分圆角

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)xq_corners_addRoundedCorners:(UIRectCorner)corners
                           withRadii:(CGSize)radii;

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)xq_corners_addRoundedCorners:(UIRectCorner)corners
                           withRadii:(CGSize)radii
                            viewRect:(CGRect)rect;

/// view to image
/// @param v 要转换的 view
+ (UIImage *)xq_convertViewToImage:(UIView *)v;

@end
















