//
//  Created by WXQ on 2020/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XQScreensShot)


/// 无损截图
/// @return 返回生成的图片
- (UIImage *)xq_screenShot;

/// 获取 scrollView 截图
+ (UIImage *)xq_screenShotWithUIScrollView:(UIScrollView *)scrollView;

/// 获取 tableview 完整内容截图
+ (UIImage *)xq_screenShotWithUITableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
