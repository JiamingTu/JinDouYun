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
- (void)getPersonInfoWithViewController:(UIViewController *)viewController {
    [self addObserver:viewController forKeyPath:kKVOPersonInfo options:NSKeyValueObservingOptionNew context:nil];
    //判断头像等信息是否更改
    BOOL isChange = [[NSUserDefaults standardUserDefaults] boolForKey:kTJMIsChangePersonInfo];
    if (isChange) {
        [self getPersonInfoWithView:viewController.view];
    } else {
        TJMPersonInfoModel *personInfoModel = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMPersonInfo];
        if (!personInfoModel) {
            [self getPersonInfoWithView:viewController.view];
        } else {
            self.personInfo = personInfoModel;
        }
    }
}

- (void)getPersonInfoWithView:(UIView *)view {
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:view message:nil];
    [TJMRequestH getPersonInfoSuccess:^(id successObj, NSString *msg) {
        self.personInfo = (TJMPersonInfoModel *)successObj;
        //将是否修改信息 改为 NO
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTJMIsChangePersonInfo];
        [progressHUD hideAnimated:YES];
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}

- (void)removePersonInfoWithViewController:(UIViewController *)viewController {
    [self removeObserver:viewController forKeyPath:kKVOPersonInfo];
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
    [TJMHUDHandle transientNoticeAtView:self.window withMessage:msg];
    if ([VC isKindOfClass:NSClassFromString(@"TJMQRCodeSingInViewController")]) {
        TJMOrderModel *model = [VC valueForKey:@"orderModel"];
        model.orderStatus = @4;
        //如果是 当前扫描界面 那就 pop 回去
        [VC.navigationController popViewControllerAnimated:YES];
    } else if ([VC isKindOfClass:NSClassFromString(@"TJMCodeSignInViewController")]) {
        TJMOrderModel *model = [VC valueForKey:@"orderModel"];
        model.orderStatus = @4;
        UIViewController *targetVC = [VC popTargetViewControllerWithViewControllerNumber:2];
        [VC.navigationController popToViewController:targetVC animated:YES];
    } else if ([VC isKindOfClass:NSClassFromString(@"TJMMyOrderDetailViewController")]) {
        TJMOrderModel *model = [VC valueForKey:@"orderModel"];
        model.orderStatus = @4;
        if ([VC respondsToSelector:@selector(setBottomButton)]) {
            [VC performSelector:@selector(setBottomButton) withObject:nil];
        }
    } else if ([VC isKindOfClass:NSClassFromString(@"TJMMyOrderViewController.h")]) {
        //我的订单页面
        TJMOrderModel *model = [VC valueForKey:@"orderModel"];
        model.orderStatus = @4;
        if ([VC respondsToSelector:@selector(reloadDataTableView)]) {
            [VC performSelector:@selector(reloadDataTableView) withObject:nil];
        }
    }

    
    
}


@end
