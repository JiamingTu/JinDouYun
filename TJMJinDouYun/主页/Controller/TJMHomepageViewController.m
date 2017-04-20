//
//  TJMHomepageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/18.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomepageViewController.h"
#import "TJMHomepageTableViewCell.h"
@interface TJMHomepageViewController ()

@end

@implementation TJMHomepageViewController
#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    TJMLog(@"%@",dateString);
    
    
    
}

#pragma  mark - 设置导航左右按钮
- (UIBarButtonItem *)setNaviItemWithImageName:(NSString *)imageName tag:(int)tag {
    UIImage *itemImage = [UIImage imageNamed:@""];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:itemImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemImage.size.width, itemImage.size.height)];
    [itemView addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemView];
    return item;
}
#pragma  mark 导航按钮绑定方法
- (void)itemAction:(UIButton *)button {
    
}
#pragma  mark - tableView delegate
#pragma  mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMHomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageCell"];
    return cell;
}
#pragma  mark UITableViewDelegate
#pragma  mark - memory warning
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
