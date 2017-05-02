//
//  TJMDetailOfMineViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMDetailOfMineViewController.h"

@interface TJMDetailOfMineViewController ()

@end

@implementation TJMDetailOfMineViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
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
