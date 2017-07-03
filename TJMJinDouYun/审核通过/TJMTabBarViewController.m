//
//  TJMTabBarViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTabBarViewController.h"
#import "TJMHomepageViewController.h"
@interface TJMTabBarViewController ()<UITabBarControllerDelegate,TDAlertViewDelegate>
{
    NSString *_newVersionURL;
}
@end

@implementation TJMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3 * TJMHeightRatio)];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.imageInsets = UIEdgeInsetsMake(-1.5, 0, 1.5, 0);
    }];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TJMFUIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TJMFUIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self checkNewVersion];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma  mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"首页"]) {
        UINavigationController *naviC = self.viewControllers.firstObject;
        TJMHomepageViewController *homeVC = naviC.viewControllers.firstObject;
        [homeVC reloadOrderList];
    }
}


- (void)checkNewVersion {
    NSDate *checkDate = [[NSUserDefaults standardUserDefaults] objectForKey:kTJMCheckVersionDate];
    if (checkDate) {
        double offsetTime = [[NSDate date] timeIntervalSinceDate:checkDate];
        double oneWeekSecond = 7 * 24 * 60 * 60;
        if (offsetTime - oneWeekSecond >= 0) {
            //检查更新
            [self checkVersionRequest];
            
            
        }
        //暂时放在这里
        [self checkVersionRequest];
        
    } else {
        //如果没有得到这个日期 则检查更新 并 储存日期
        [self checkVersionRequest];
    }
    
}

- (void)checkVersionRequest {
    [TJMRequestH checkVersionSuccess:^(id successObj, NSString *msg) {
        if (successObj != nil) {
            _newVersionURL = successObj;
            [self alertViewWithTag:9999 delegate:self title:@"提示：有新版本可更新" cancelItem:@"取消" sureItem:@"更新"];
        }
    } fail:^(NSString *failString) {
        
    }];
    //储存检查日期
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kTJMCheckVersionDate];
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        // 跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps:%@",_newVersionURL]]];
    }
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
