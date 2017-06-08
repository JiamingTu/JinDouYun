//
//  AppDelegate+APPService.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (APPService)
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
- (void)getPersonInfoWithViewController:(UIViewController *)viewController;
/**移除个人信息监听*/
- (void)removePersonInfoWithViewController:(UIViewController *)viewController;

/**设置引导页*/
- (void)setGuidePage;
@end
