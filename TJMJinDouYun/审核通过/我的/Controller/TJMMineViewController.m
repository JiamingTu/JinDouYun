//
//  TJMMineViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMineViewController.h"
#import "TJMMineTableViewCell.h"

@interface TJMMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSArray *nameArray;


@end

@implementation TJMMineViewController
#pragma  mark - lazy loading
- (NSArray *)nameArray {
    if (!_nameArray) {
        NSArray *firstSecArray = @[@"我的订单",@"收到的评价"];
        NSArray *secondSecArray = @[@"应急中心",@"关于我们"];
        NSArray *thirdSecArray = @[@"设置"];
        self.nameArray = @[firstSecArray,secondSecArray,thirdSecArray];
    }
    return _nameArray;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //navigationBar 变透明
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TJMMineCell" forIndexPath:indexPath];
    
    cell.label.text = self.nameArray[indexPath.section][indexPath.row];
    
    
    return cell;
}
#pragma  mark - UITableViewDelegate
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
//    
//    
//    return view;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
