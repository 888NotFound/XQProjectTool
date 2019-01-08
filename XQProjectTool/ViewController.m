//
//  ViewController.m
//  XQProjectTool
//
//  Created by WXQ on 2018/4/2.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "ViewController.h"
//#import "XQKeychain.h"
//#import "UIImage+SubImage.h"
//#import "XQIPAddress.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[
                     @"测试",
                     ];
    [self.view addSubview:self.tableView];
}

static NSString *reusing_ = @"VCCell";
#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusing_ forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", [XQKeychain getUUIDStr]);
//    [XQKeychain saveUUIDStr:@"asdwqe"];
    
//    UIImage *img = [[UIImage imageNamed:@"1.jpg"] rescaleImageToSize:CGSizeMake(2000, 1000)];
//    NSLog(@"%@", img);
    
//    NSLog(@"%@", [XQIPAddress getIPAddresses]);
//    NSLog(@"%@", [XQIPAddress getWANIPAddress]);
//    NSLog(@"%@", [XQIPAddress getInIPAddress]);
    
}

#pragma mark -- get

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reusing_];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end












