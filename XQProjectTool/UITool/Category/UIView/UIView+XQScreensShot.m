//
//  Created by WXQ on 2020/4/25.
//

#import "UIView+XQScreensShot.h"

@implementation UIView (XQScreensShot)

/// 无损截图
/// @return 返回生成的图片
- (UIImage *)xq_screenShot {
    if (self && self.frame.size.height && self.frame.size.width) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
        
    }
    
    return nil;
}

/// 获取 scrollView 截图
+ (UIImage *)xq_screenShotWithUIScrollView:(UIScrollView *)scrollView {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame =  scrollView.frame;

        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();

        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    return image;
}

/// 获取 tableview 完整内容截图
+ (UIImage *)xq_screenShotWithUITableView:(UITableView *)tableView {
    CGPoint savedContentOffset = tableView.contentOffset;
    ///计算画布所需实际高度
    CGFloat contentHeight = 0;
    if (tableView.tableHeaderView) {
        contentHeight += tableView.tableHeaderView.frame.size.height;
    }
    
    NSInteger sections = tableView.numberOfSections;
    for (NSInteger i = 0; i < sections; i++) {
        contentHeight += [tableView rectForHeaderInSection:i].size.height;

        NSInteger rows = [tableView numberOfRowsInSection:i];
        for (NSInteger j = 0; j < rows; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            contentHeight += cell.frame.size.height;
        }

        contentHeight += [tableView rectForFooterInSection:i].size.height;
    }
    
    if (tableView.tableFooterView) {
        contentHeight += tableView.tableFooterView.frame.size.height;
    }

    ///创建画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tableView.frame.size.width, contentHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    ///把所有的视图 render到CGContext上
    if (tableView.tableHeaderView) {
        contentHeight = tableView.tableHeaderView.frame.size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        [tableView.tableHeaderView.layer renderInContext:ctx];
        CGContextTranslateCTM(ctx, 0, tableView.tableHeaderView.frame.size.height);
    }
    
    for (NSInteger i = 0; i < sections; i++) {
        ///sectionHeader
        contentHeight += [tableView rectForHeaderInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *headerView = [tableView headerViewForSection:i];
        if (headerView) {
            [headerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, headerView.frame.size.height);
        }
        
        ///Cell
        NSInteger rows = [tableView numberOfRowsInSection:i];
        for (NSInteger j = 0; j < rows; j++) {
            //讓該cell被正確的產生在tableView上, 之後才能在CGContext上正確的render出來
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            contentHeight += cell.frame.size.height;
            [cell.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, cell.frame.size.height);
        }
        
        ///sectionFooter
        contentHeight += [tableView rectForFooterInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *footerView = [tableView footerViewForSection:i];
        if (footerView) {
            [footerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, footerView.frame.size.height);
        }
    }

    if (tableView.tableFooterView) {
        tableView.contentOffset = CGPointMake(0, tableView.contentSize.height-tableView.frame.size.height);
        [tableView.tableFooterView.layer renderInContext:ctx];
        //CGContextTranslateCTM(ctx, 0, tableView.tableFooterView.frame.size.height);
    }

    ///生成UIImage对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    tableView.contentOffset = savedContentOffset;
    return image;
}

/// WKWebView 截图
+ (void)xq_screenshotWithWebView:(WKWebView *)webView callback:(void(^)(UIImage *img))callback {
    
    UIScrollView *scrollView = webView.scrollView;
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    
    if (scrollView.contentSize.height <= scrollView.bounds.size.height) {
        // 小于高度，直接截图
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (callback) {
            callback(img);
        }
    }else {
        // 大于高度，拼接
        [self xq_screenshotLongWithWebView:webView callback:callback];
    }
}

+ (void)xq_screenshotLongWithWebView:(WKWebView *)webView callback:(void(^)(UIImage *img))callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat screenshotY = webView.scrollView.contentOffset.y;
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, webView.bounds.size.height);
        
        if ((webView.scrollView.contentOffset.y + webView.bounds.size.height) >= webView.scrollView.contentSize.height) {
            // 最后了
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (callback) {
                callback(img);
            }
        }else {
            
            CGFloat y = webView.scrollView.contentOffset.y + webView.bounds.size.height;
            
            // 不用判断这个了，直接拼上
            // 不过界面 setContentOffset 会有点问题，会超过 webview 最大内容.
//            CGFloat maxY = webView.scrollView.contentSize.height - webView.bounds.size.height;
//
//            if (y > maxY) {
//                // 最后一张了
//                y = maxY;
//            }
            
            // 继续截图
            [webView.scrollView setContentOffset:CGPointMake(0, y) animated:NO];
            [self xq_screenshotLongWithWebView:webView callback:callback];
        }
    });
}

@end




