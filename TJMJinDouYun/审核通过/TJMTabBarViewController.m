//
//  TJMTabBarViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTabBarViewController.h"
#import "TJMHomepageViewController.h"
#import "TJMMessageViewController.h"
@interface TJMTabBarViewController ()<UITabBarControllerDelegate,TDAlertViewDelegate>
{
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
    
    //添加监听，msgBadgeValue改变时，改变角标值
    [self.appDelegate addObserver:self forKeyPath:@"msgBadgeValue" options:NSKeyValueObservingOptionNew context:nil];
    //首次加载页面时获取本地badge的值 并显示
    [self getBadgeFromInfoPlist];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [self.appDelegate removeObserver:self forKeyPath:@"msgBadgeValue"];
}

#pragma  mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //取消所有请求
    [TJMRequestH httpRequestManagerCancelRequest];
    if ([item.title isEqualToString:@"首页"]) {
        UINavigationController *naviC = self.viewControllers.firstObject;
        TJMHomepageViewController *homeVC = naviC.viewControllers.firstObject;
        [homeVC reloadOrderList];
    } else if ([item.title isEqualToString:@"消息"]) {
        UINavigationController *naviC = self.viewControllers[2];
        TJMMessageViewController *msgVC = naviC.viewControllers.firstObject;
        [msgVC refreshList];
    }
}

#pragma  mark - 消息模块显示数量
- (void)getBadgeFromInfoPlist {
    NSNumber *number = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMUnreadMessageNum];
    self.appDelegate.msgBadgeValue = number;
    //并网络请求
    [TJMRequestH getUnreadMessageNumberWithSuccess:^(id successObj, NSString *msg) {
        NSNumber *number = successObj;
        self.appDelegate.msgBadgeValue = number;
    } fail:^(NSString *failString) {
        
    }];
}
#pragma  mark 消息item 添加badge
- (void)addMessageBadgeWithValue:(NSNumber *)badge {
    UITabBarItem *item = self.tabBar.items[2];
    NSString *badgeString = nil;
    if ([badge integerValue] > 99) {
        badgeString = @"...";
    } else if (badge.integerValue == 0) {
        badgeString = nil;
    } else {
        badgeString = badge.description;
    }
    item.badgeValue = badgeString;
}

#pragma  mark - 版本跟新
- (void)checkNewVersion {
    NSDate *checkDate = [[NSUserDefaults standardUserDefaults] objectForKey:kTJMCheckVersionDate];
    if (checkDate) {
        double offsetTime = [[NSDate date] timeIntervalSinceDate:checkDate];
        double oneWeekSecond = 7 * 24 * 60 * 60;
        if (offsetTime - oneWeekSecond >= 0) {
            //检查更新
            [self checkVersionRequest];
        }
    } else {
        //如果没有得到这个日期 则检查更新 并 储存日期
        [self checkVersionRequest];
    }
    
}

- (void)checkVersionRequest {
    [TJMRequestH checkVersionSuccess:^(id successObj, NSString *msg) {
        if (successObj != nil) {
            NSString *nowVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
            if (![nowVersion isEqualToString:successObj]) {
                [self alertViewWithTag:9999 delegate:self title:@"提示：有新版本可更新" cancelItem:@"取消" sureItem:@"更新"];
            }
        }
    } fail:^(NSString *failString) {
        
    }];
    //储存检查日期
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kTJMCheckVersionDate];
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",AppleID];
        // 跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //self.appDelegate.msgBadgeValue 值改变时跟新badgeValue
    if ([keyPath isEqualToString:@"msgBadgeValue"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self addMessageBadgeWithValue:self.appDelegate.msgBadgeValue];
        }];
    }
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
