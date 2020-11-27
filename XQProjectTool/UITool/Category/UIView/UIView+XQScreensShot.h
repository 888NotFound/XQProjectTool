//
//  Created by WXQ on 2020/4/25.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XQScreensShot)


/// 获取view截图
/// @return 返回生成的图片
- (UIImage *)xq_screenShot;

/// 获取 scrollView 截图
+ (UIImage *)xq_screenShotWithUIScrollView:(UIScrollView *)scrollView;

/// 获取 tableview 完整内容截图
+ (UIImage *)xq_screenShotWithUITableView:(UITableView *)tableView;

/// 获取 WKWebView 完整内容截图
+ (void)xq_screenshotWithWebView:(WKWebView *)webView callback:(void(^)(UIImage *img))callback;

@end

NS_ASSUME_NONNULL_END
