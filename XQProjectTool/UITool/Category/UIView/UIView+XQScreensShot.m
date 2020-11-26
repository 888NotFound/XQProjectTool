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

    NSInteger sections = tableView.numberOfSections;
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

@end




