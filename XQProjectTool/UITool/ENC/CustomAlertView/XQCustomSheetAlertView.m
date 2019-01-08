//
//  XQCustomSheetAlertView.m
//  XQP2PCamera
//
//  Created by WXQ on 2018/5/26.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "XQCustomSheetAlertView.h"
#import "XQCustomSheetAlertViewCell.h"
#import "XQCustomSheetAlertTopView.h"
#import "UIView+XQLine.h"
#import "XQCustomSheetAlertFooterView.h"
#import <Masonry/Masonry.h>
#import "XQIOSDevice.h"

#define XQ_Screen_Width [UIScreen mainScreen].bounds.size.width
#define XQ_Screen_Height [UIScreen mainScreen].bounds.size.height

@interface XQCustomSheetAlertView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *backView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) XQCustomSheetAlertTopView *headerView;
@property (nonatomic, strong) XQCustomSheetAlertFooterView *footerView;

@property (nonatomic, copy) XQCustomSheetAlertViewCallback callback;
@property (nonatomic, copy) XQCustomSheetAlertViewCallback cancelCallback;

@property (nonatomic, copy) NSString *cancelText;

/** tableView的字颜色 */
@property (nonatomic, strong) NSMutableDictionary *fontColorDic;

@end

@implementation XQCustomSheetAlertView

static XQCustomSheetAlertView *saView_ = nil;
static CGFloat asCellHeight_ = 60;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backView = [UIButton new];
        [self insertSubview:self.backView atIndex:0];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.backView addTarget:self action:@selector(respondsToBack:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(100);
        }];
        self.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

+ (void)sheetWithTitle:(NSString *)title message:(NSString *)message dataArr:(NSArray <NSString *> *)dataArr cancelText:(NSString *)cancelText callback:(XQCustomSheetAlertViewCallback)callback cancelCallback:(XQCustomSheetAlertViewCallback)cancalCallback {
    if (saView_) {
        return;
    }
    
    saView_ = [XQCustomSheetAlertView new];
    saView_.callback = callback;
    saView_.cancelCallback = cancalCallback;
    saView_.cancelText = cancelText;
    saView_.dataArr = dataArr;
    
    if (title.length != 0 || message.length != 0) {
        saView_.headerView = [[XQCustomSheetAlertTopView alloc] initWithFrame:CGRectMake(0, 0, XQ_Screen_Width, 0)];
        saView_.headerView.backgroundColor = [UIColor whiteColor];
        saView_.headerView.titleLab.text = title;
        saView_.headerView.messageLab.text = message;
        CGFloat height = [saView_.headerView getViewHeight];
        saView_.headerView.frame = CGRectMake(0, 0, XQ_Screen_Width, height);
        saView_.tableView.tableHeaderView = saView_.headerView;
    }
    
    if (cancelText.length != 0) {
        saView_.footerView = [XQCustomSheetAlertFooterView new];
        [saView_.footerView.btn setTitle:cancelText forState:UIControlStateNormal];
        [saView_.footerView.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [saView_ addSubview:saView_.footerView];
        [saView_.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(saView_);
            make.height.mas_equalTo([saView_ getFooterHeight]);
            make.bottom.equalTo(saView_).offset([saView_ getAlertHeight] + [saView_ getFooterHeight]);
        }];
        __weak typeof(saView_) weakSelf = saView_;
        saView_.footerView.callback = ^{
            [weakSelf hide];
            if (weakSelf.cancelCallback) {
                weakSelf.cancelCallback(0);
            }
        };
    }
    
    [saView_ setTableLayoutWithIsHide:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:saView_];
    [saView_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}

+ (void)setItemColorWithColor:(UIColor *)color rows:(NSArray <NSNumber *> *)rows {
    if (!saView_) {
        return;
    }
    
    if (rows.count == 0) {
        return;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSNumber *number in rows) {
        if (number.intValue >= saView_.dataArr.count || number.intValue < 0) {
            return;
        }
        NSString *key = [NSString stringWithFormat:@"%d", number.intValue];
        [saView_.fontColorDic addEntriesFromDictionary:@{key: color}];
        [indexPaths addObject:[NSIndexPath indexPathForRow:number.intValue inSection:0]];
    }
    
    [saView_.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

+ (void)setItemColorWithColor:(UIColor *)color row:(NSInteger)row {
    [self setItemColorWithColor:color rows:@[@(row)]];
}

+ (void)setCancelItemColorWithColor:(UIColor *)color {
    if (!saView_ || !saView_.footerView) {
        return;
    }
    
    [saView_.footerView.btn setTitleColor:color forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.headerView) {
        [UIView setBorderWithView:self.headerView top:NO left:NO bottom:YES right:NO borderColor:[UIColor lightGrayColor] borderWidth:1];
    }
    
    // 0.0 因为是用约束...得等布局完毕, 再进行动画
    [self show];
}

- (void)show {
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, XQ_Screen_Height, self.tableView.frame.size.width, self.tableView.frame.size.height);
        self.footerView.frame = CGRectMake(0, XQ_Screen_Height + self.tableView.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        self.backView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        saView_ = nil;
    }];
}

- (CGFloat)getAlertHeight {
    CGFloat height = asCellHeight_ * self.dataArr.count + self.headerView.frame.size.height;
    CGFloat maxHeight = XQ_Screen_Height - [XQIOSDevice getNavigationHeight] - 20 - (self.cancelText.length == 0 ? 0 : [self getFooterHeight]);
    if (height > maxHeight) {
        height = maxHeight;
    }
    return height;
}

- (CGFloat)getFooterHeight {
    return asCellHeight_ + 10;
}

- (void)setTableLayoutWithIsHide:(BOOL)isHide {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //isHide ? make.top.equalTo(self.mas_bottom) : make.bottom.equalTo(self.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self getAlertHeight]);
    }];
}

#pragma mark -- responds

- (void)respondsToBack:(id)sender {
    [self hide];
    if (self.cancelCallback) {
        self.cancelCallback(-1);
    }
}

static NSString *reusing_ = @"XQCustomSheetAlertViewCell";

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XQCustomSheetAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusing_ forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.titleLab.text = self.cancelText;
    }else {
        cell.titleLab.text = self.dataArr[indexPath.row];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if (self.fontColorDic[key]) {
        cell.titleLab.textColor = self.fontColorDic[key];
    }else {
        cell.titleLab.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (self.callback) {
        self.callback(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark -- get

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        
        UINib *nib = [UINib nibWithNibName:reusing_ bundle:[NSBundle bundleForClass:[XQCustomSheetAlertViewCell class]]];
        [_tableView registerNib:nib forCellReuseIdentifier:reusing_];
        
        _tableView.rowHeight = asCellHeight_;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableDictionary *)fontColorDic {
    if (!_fontColorDic) {
        _fontColorDic = [NSMutableDictionary dictionary];
    }
    return _fontColorDic;
}

- (void)dealloc {
    NSLog(@"sheet弹框销毁");
}

@end























