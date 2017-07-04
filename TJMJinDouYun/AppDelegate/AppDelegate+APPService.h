//
//  AppDelegate+APPService.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate.h"

typedef void(^AppSerFailBlock)(NSString *failMsg);

@interface AppDelegate (APPService)<TDAlertViewDelegate>
/*
 *验证登录状态并进入相应界面
 */
- (void)checkLoggingStatusWithToken;

/*
 * 更改根视图时的淡出动画
 * @param rootViewController 将要跳转的rootViewController
 */
- (void)restoreRootViewController:(UIViewController *)rootViewController;
/**获取个人信息并监听*/
- (void)getFreeManInfoWithViewController:(UIViewController *)viewController fail:(AppSerFailBlock)failure;
/**移除个人信息监听*/
- (void)removeFreeManInfoWithViewController:(UIViewController *)viewController;

/**设置引导页*/
- (void)setGuidePage;

- (void)receivedSignInMessageWithBlock:(SignInBlock)signIn;

/**获取当前视图控制器*/
- (UIViewController *)topViewController;

/**位置权限*/
- (void)getLocationAuthorization;
@end
