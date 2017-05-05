//
//  TJMMessageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMessageViewController.h"
#import "TJMMessageTableViewCell.h"
@interface TJMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TJMMessageViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViews];
}

#pragma  mark - 设置页面
- (void)configViews {
    [self setTitle:@"消息" fontSize:17 colorHexValue:0x333333];
    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
    self.tableView.contentInset = UIEdgeInsetsMake(10 * TJMHeightRatio, 0, 0, 0);
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    NSLog(@"%zd",tableView.visibleCells.count);
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66 * TJMHeightRatio;
}
#pragma  mark memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
