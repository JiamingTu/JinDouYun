//
//  HomepageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "HomepageViewController.h"

@interface HomepageViewController ()

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
