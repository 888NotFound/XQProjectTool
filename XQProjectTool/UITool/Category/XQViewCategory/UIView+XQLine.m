//
//  UIView+XQLine.m
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "UIView+XQLine.h"

@implementation UIView (XQLine)


/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    for (CALayer *layer in lineView.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
        //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
        // 第一个线的长, 第二个是间隔
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:lineSpacing], nil]];
        //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
        //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
        // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
        // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
        // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
        // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, [UIColor greenColor].CGColor);
        // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 300, 2.0);
    
    CGContextStrokePath(line);
    
        // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    [self setBorderWithView:view top:top left:left bottom:bottom right:right borderColor:color borderWidth:width headSpacing:0 footSpacing:0];
}



+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width {
    if (direction & XQUIViewBorderDirectionTop) {
        [self setBorderWithView:view top:YES left:NO bottom:NO right:NO borderColor:color borderWidth:width];
    }
    
    if (direction & XQUIViewBorderDirectionBottom) {
        [self setBorderWithView:view top:NO left:NO bottom:YES right:NO borderColor:color borderWidth:width];
    }
    
    if (direction & XQUIViewBorderDirectionLeft) {
        [self setBorderWithView:view top:NO left:YES bottom:NO right:NO borderColor:color borderWidth:width];
    }
    
    if (direction & XQUIViewBorderDirectionRight) {
        [self setBorderWithView:view top:NO left:NO bottom:NO right:YES borderColor:color borderWidth:width];
    }
    
}

/**
 视图边界线, 这里是用layer的方式
 需要注意的是, 如果传进来的view, frame是0, 那么画图也是0
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param footSpacing 线, 距离尾部距离
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 headSpacing:(CGFloat)headSpacing
                 footSpacing:(CGFloat)footSpacing
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width {
    if (direction & XQUIViewBorderDirectionTop) {
        [self setBorderWithView:view top:YES left:NO bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing];
    }
    
    if (direction & XQUIViewBorderDirectionBottom) {
        [self setBorderWithView:view top:NO left:NO bottom:YES right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing];
    }
    
    if (direction & XQUIViewBorderDirectionLeft) {
        [self setBorderWithView:view top:NO left:YES bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing];
    }
    
    if (direction & XQUIViewBorderDirectionRight) {
        [self setBorderWithView:view top:NO left:NO bottom:NO right:YES borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing];
    }
}

/**
 视图边界线, 这里是用layer的方式
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param lineWidth 线的长度
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 headSpacing:(CGFloat)headSpacing
                   lineWidth:(CGFloat)lineWidth
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width {
    if (direction & XQUIViewBorderDirectionTop) {
        [self setBorderWithView:view top:YES left:NO bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth];
    }
    
    if (direction & XQUIViewBorderDirectionBottom) {
        [self setBorderWithView:view top:NO left:NO bottom:YES right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth];
    }
    
    if (direction & XQUIViewBorderDirectionLeft) {
        [self setBorderWithView:view top:NO left:YES bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth];
    }
    
    if (direction & XQUIViewBorderDirectionRight) {
        [self setBorderWithView:view top:NO left:NO bottom:NO right:YES borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth];
    }
}


+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width headSpacing:(CGFloat)headSpacing footSpacing:(CGFloat)footSpacing {
    [self setBorderWithView:view top:top left:left bottom:bottom right:right borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing lineWidth:0];
}

/**
 视图边界线, 这里是用layer的方式, 自定义线宽度
 
 @note 这样是完美了, 但却是过于麻烦, 填的参数过多
 
 @param view 需要添加layer的视图
 @param headSpacing 线, 距离头部距离
 @param lineWidth 线的长度, 自定义长度, 而不是跟着view当前的size来
 @param y 如果是 .bottom 那么就是 y, 如果是 .right 那么就是 x
 */
+ (void)xq_setBorderWithView:(UIView *)view
                   direction:(XQUIViewBorderDirection)direction
                 headSpacing:(CGFloat)headSpacing
                   lineWidth:(CGFloat)lineWidth
                 borderColor:(UIColor *)color
                 borderWidth:(CGFloat)width
                           y:(CGFloat)y {
    if (direction & XQUIViewBorderDirectionTop) {
        [self setBorderWithView:view top:YES left:NO bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth y:y];
    }
    
    if (direction & XQUIViewBorderDirectionBottom) {
        [self setBorderWithView:view top:NO left:NO bottom:YES right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth y:y];
    }
    
    if (direction & XQUIViewBorderDirectionLeft) {
        [self setBorderWithView:view top:NO left:YES bottom:NO right:NO borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth y:y];
    }
    
    if (direction & XQUIViewBorderDirectionRight) {
        [self setBorderWithView:view top:NO left:NO bottom:NO right:YES borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:0 lineWidth:lineWidth y:y];
    }
}

/**
 画边线

 @param lineWidth 如果是 0, 则忽略
 */
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width headSpacing:(CGFloat)headSpacing footSpacing:(CGFloat)footSpacing lineWidth:(CGFloat)lineWidth {
    [self setBorderWithView:view top:top left:left bottom:bottom right:right borderColor:color borderWidth:width headSpacing:headSpacing footSpacing:footSpacing lineWidth:lineWidth y:0];
}

/**
 画边线
 
 @param lineWidth 如果是 0, 则忽略
 */
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width headSpacing:(CGFloat)headSpacing footSpacing:(CGFloat)footSpacing lineWidth:(CGFloat)lineWidth y:(CGFloat)y {
    if (top) {
        CALayer *layer = [CALayer layer];
        
        CGFloat layerWidth = 0;
        if (lineWidth <= 0) {
            layerWidth = view.frame.size.width - headSpacing - footSpacing;
        }else {
            layerWidth = lineWidth;
        }
        
        layer.frame = CGRectMake(headSpacing, 0, layerWidth, width);
        
        
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        
        CGFloat layerWidth = 0;
        if (lineWidth <= 0) {
            layerWidth = view.frame.size.height - headSpacing - footSpacing;
        }else {
            layerWidth = lineWidth;
        }
        
        layer.frame = CGRectMake(0, headSpacing, width, layerWidth);
        
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    
    if (bottom) {
        CALayer *layer = [CALayer layer];
        
        CGFloat layerWidth = 0;
        if (lineWidth <= 0) {
            layerWidth = view.frame.size.width - headSpacing - footSpacing;
        }else {
            layerWidth = lineWidth;
        }
        
        CGFloat layerY = 0;
        if (y <= 0) {
            layerY = view.frame.size.height - width;
        }else {
            layerY = y;
        }
        
        layer.frame = CGRectMake(headSpacing, layerY, layerWidth, width);
        
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    
    if (right) {
        CALayer *layer = [CALayer layer];
        
        CGFloat layerWidth = 0;
        if (lineWidth <= 0) {
            layerWidth = view.frame.size.height - headSpacing - footSpacing;
        }else {
            layerWidth = lineWidth;
        }
        
        CGFloat layerY = 0;
        if (y <= 0) {
            layerY = view.frame.size.width - width;
        }else {
            layerY = y;
        }
        
        layer.frame = CGRectMake(layerY, headSpacing, width, layerWidth);
        
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}


#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)xq_corners_addRoundedCorners:(UIRectCorner)corners
                           withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)xq_corners_addRoundedCorners:(UIRectCorner)corners
                           withRadii:(CGSize)radii
                            viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

+ (UIImage *)xq_convertViewToImage:(UIView *)v {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end






















