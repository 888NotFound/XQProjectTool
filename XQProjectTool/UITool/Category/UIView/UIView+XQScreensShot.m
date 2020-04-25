//
//  Created by WXQ on 2020/4/25.
//

#import "UIView+XQScreensShot.h"

@implementation UIView (XQScreensShot)

/// 无损截图
/// @return 返回生成的图片
- (UIImage *)xq_screenShot {
    if (self && self.frame.size.height && self.frame.size.width) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
        
    }
    
    return nil;
}

@end




