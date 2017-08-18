//
//  AppDelegate+APPService.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate+APPService.h"
#import "TJMTabBarViewController.h"
#import "TJMEntryCheckViewController.h"
#import "LaunchIntroductionView.h"

#import "TJMQRCodeSingInViewController.h"
@implementation AppDelegate (APPService)
#pragma  mark - 确认登录状态
//确认登录状态（是否存在token）
- (void)checkLoggingStatusWithToken {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        //token 存在，资料、考试通过后才进入首页 否则进入成为自由人页面
        //进入首页
        TJMLog(@"token存在 判断审核、学习状态");
        TJMFreeManInfo *info = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMFreeManInfo];
        if (info) {
            if (info.materialStatus.integerValue == 2 && info.examStatus.integerValue == 4) {
                //考试和资料审核都通过
                TJMTabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TJMTabBarController"];
                self.window.rootViewController = tabBarVC;
            } else {
                //审核未通过
                UINavigationController *uncheckedNaviC = [storyboard instantiateViewControllerWithIdentifier:@"TJMUncheckedNaviController"];
                UIViewController *naviRootVC = [uncheckedNaviC.viewControllers firstObject];
                TJMEntryCheckViewController *entryCheckVC = [storyboard instantiateViewControllerWithIdentifier:@"EntryCheck"];
                entryCheckVC.freeManInfo = info;
                //直接进入未审核页面
                [uncheckedNaviC setViewControllers:@[naviRootVC,entryCheckVC]];
                self.window.rootViewController = uncheckedNaviC;
            }
        }
        
    }else {
        //token 进入未登录页面 UIStoryboard
        TJMLog(@"token 不存在");
        UINavigationController *uncheckedNaviC = [storyboard instantiateViewControllerWithIdentifier:@"TJMUncheckedNaviController"];
        self.window.rootViewController = uncheckedNaviC;
    }
    //更新个人信息
    [TJMRequestH getPersonInfoSuccess:^(id successObj, NSString *msg) {
    } fail:^(NSString *failString) {
        
    }];
}

#pragma  mark - 更改根视图 动画
- (void)restoreRootViewController:(UIViewController *)rootViewController
{
    typedef void (^Animation)(void);
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:self.window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];    
}

#pragma  mark - 获取个人信息
- (void)getFreeManInfoWithViewController:(UIViewController *)viewController fail:(AppSerFailBlock)failure {
    [self addObserver:viewController forKeyPath:kKVOFreeManInfo options:NSKeyValueObservingOptionNew context:nil];
    //判断头像等信息是否更改
    BOOL isChange = [[NSUserDefaults standardUserDefaults] boolForKey:kTJMIsChangePersonInfo];
    if (isChange) {
        [self getFreeManInfoWithFail:^(NSString *failString) {
            failure(failString);
        }];
    } else {
        TJMFreeManInfo *freeManInfo = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMFreeManInfo];
        if (!freeManInfo) {
            [self getFreeManInfoWithFail:^(NSString *failString) {
                failure(failString);
            }];
        } else {
            self.freeManInfo = freeManInfo;
        }
    }
}

- (void)getFreeManInfoWithFail:(AppSerFailBlock)fail {
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
        self.freeManInfo = (TJMFreeManInfo *)successObj;
        //将是否修改信息 改为 NO
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTJMIsChangePersonInfo];
    } fail:^(NSString *failString) {
        fail(failString);
    }];
}

- (void)removeFreeManInfoWithViewController:(UIViewController *)viewController {
    [self removeObserver:viewController forKeyPath:kKVOFreeManInfo];
}

#pragma  mark - 设置引导页
- (void)setGuidePage {
    CGFloat height = 37 * TJMHeightRatio;
    CGFloat width = 134 * TJMWidthRatio;
    CGRect frame = CGRectMake(TJMScreenWidth / 2 - width / 2 , TJMScreenHeight - 90 *TJMHeightRatio, width, height);
    [LaunchIntroductionView sharedWithImages:@[@"引导页1",@"引导页2",@"引导页3"] buttonImage:@"立即体验" buttonFrame:frame];
}

#pragma mark - 获取当前VC 
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma  mark - 收到签收成功消息后
- (void)receivedSignInMessageWithBlock:(SignInBlock)signIn {
    NSString *msg = signIn();
    UIViewController *VC = [self topViewController];
    [TJMHUDHandle hiddenHUDForView:VC.view];
    [TJMHUDHandle transientNoticeAtView:self.window withMessage:msg];
    //判断
    if ([VC isKindOfClass:NSClassFromString(@"TJMHomepageViewController")]) {
        [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
    } else {
        //除了上一种情况 其他的 都需要更新model状态
        TJMOrderModel *model = [VC valueForKey:@"orderModel"];
        [TJMRequestH getSingleOrderWithOrderNumber:model.orderNo success:^(id successObj, NSString *msg) {
            TJMOrderModel *newModel = successObj;
            model.payStatus = newModel.payStatus;
            model.orderStatus = newModel.orderStatus;
            model.finishTime = model.finishTime;
            [self receivedSignInMessageAndOrderDidUpdateWithViewController:VC];
        } fail:^(NSString *failString) {
            [TJMHUDHandle transientNoticeAtView:self.window withMessage:@"订单更新失败，请返回刷新"];
        }];
    }
    
}

- (void)receivedSignInMessageAndOrderDidUpdateWithViewController:(UIViewController *)VC {
    if ([VC isKindOfClass:NSClassFromString(@"TJMQRCodeSingInViewController")])
    {
        //如果是 当前扫描界面 那就 pop 回去
        [VC.navigationController popViewControllerAnimated:YES];
    }
    else if ([VC isKindOfClass:NSClassFromString(@"TJMCodeSignInViewController")])
    {
        UIViewController *targetVC = [VC popTargetViewControllerWithViewControllerNumber:2];
        [VC.navigationController popToViewController:targetVC animated:YES];
    }
    else if ([VC isKindOfClass:NSClassFromString(@"TJMMyOrderDetailViewController")])
    {
        UITableView *tableView = [VC valueForKey:@"tableView"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([VC respondsToSelector:@selector(setBottomButton)]) {
            [tableView reloadData];
            [VC performSelector:@selector(setBottomButton) withObject:nil];
        }
    }
    else if ([VC isKindOfClass:NSClassFromString(@"TJMMyOrderViewController.h")])
    {
        //我的订单页面
        if ([VC respondsToSelector:@selector(reloadDataTableView)]) {
            [VC performSelector:@selector(reloadDataTableView) withObject:nil];
#pragma clang diagnostic pop
        }
    }
    else if ([VC isKindOfClass:NSClassFromString(@"TJMDeliveryPayViewController")])
    {
        //如果是 当前扫描界面 那就 pop 回去
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [VC.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)getLocationAuthorization {
    //请开启定位服务
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        //当前应用名
        NSString *appCurName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"为了不影响您的使用，请到设置->隐私->定位服务中开启%@定位服务",appCurName];
        [self alertViewWithTag:10000 delegate:self title:@"温馨提示" message:message cancelItem:@"取消" sureItem:@"确认"];
        
    }
}

- (void)alertViewWithTag:(NSInteger)tag delegate:(id<TDAlertViewDelegate>)delegate title:(NSString *)title message:(NSString *)message cancelItem:(NSString *)cancel sureItem:(NSString *)sure {
    TDAlertItem *sureItem = [[TDAlertItem alloc]initWithTitle:sure titleColor:TJMFUIColorFromRGB(0x666666)];
    TDAlertItem *cancelItem = [[TDAlertItem alloc]initWithTitle:cancel titleColor:TJMFUIColorFromRGB(0xffdf22)];
    NSArray *items = @[sureItem,cancelItem];
    TDAlertView *alertView = [[TDAlertView alloc]initWithTitle:title message:message items:items delegate:delegate];
    alertView.tag = tag;
    alertView.alertWidth = 280 * TJMHeightRatio;
    alertView.optionsRowHeight = 45 * TJMHeightRatio;
    [alertView show];
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
