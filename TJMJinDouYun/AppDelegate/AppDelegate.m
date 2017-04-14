//
//  AppDelegate.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+SDKSevice.h"
#import "AppDelegate+APPService.h"
@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    
    //登录验证
    [self checkLoggingStatusWithToken];
    
    
#warning 需写在block里
    __weak AppDelegate *weakSelf = self;
    self.InitBaiduMapEngine = ^() {
        [weakSelf startBaiduMapEngine];
    };
    
    self.InitNaviServices = ^() {
        [weakSelf startBaiduMapNaviServicesWithResult:^{
            NSLog(@"异步开启成功");
            weakSelf.GetResult();
        }];
    };
    
    return YES;
}
#pragma mark BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError {
    if (iError == 0) {
        NSLog(@"网络正常");
    }else {
        NSLog(@"网络出错,%@",@(iError));
    }
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参考BMKPermissionCheckResultCode
 */
- (void)onGetPzermissionState:(int)iError {
    if (iError == 0) {
        NSLog(@"验证成功");
    }else {
        NSLog(@"验证失败,%d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
