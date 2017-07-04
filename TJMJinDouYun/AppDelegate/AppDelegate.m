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
@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    [TJMSandBoxManager clearCacheEveryTwoWeeks];
    //登录验证
    [self checkLoggingStatusWithToken];
    //引导页
    [self setGuidePage];
    
    //极光推送
    [self registerJPush];
    [self startJPushWithLaunchOptions:launchOptions];
    
    //微信
    BOOL result = [WXApi registerApp:TJM_WX_AppID];
    TJMLog(@"%zd",result);
    
    return YES;
}


//上报 deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    TJMLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//打开URL
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    return  [WXApi handleOpenURL:url delegate:self];
}
#else
//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。
//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];//通报服务器，角标数量为0，否则有推送消息会在之前基础上加1
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
#else 
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
#endif
    //进入后台 关闭 定时器（如果有）
    if (self.stopTimer) {
        self.stopTimer();
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //将要进入前台，首页开工时长等需要重新获取
    if (self.workTimeBlock) {
        self.workTimeBlock();
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma  mark - 内存警告
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //1.清空缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
    //2.取消当前的下载操作
    [[SDWebImageManager sharedManager] cancelAll];
    //删除缓存文件夹
    [TJMSandBoxManager clearCache];
}

#pragma  mark - 微信支付回调
//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void)onResp:(BaseResp *)resp {
    //启动微信支付的response
    NSString *payResult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0: {
                payResult = @"支付结果：成功！";
                [self receivedSignInMessageWithBlock:^NSString *{
                    return payResult;
                }];
            }
                break;
            case -1: {
                payResult = @"支付结果：失败！";
                
            }
                break;
            case -2: {
                payResult = @"您已经退出支付！";
            }
                break;
            default: {
                payResult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            }
                break;
        }
        if (resp.errCode != 0) {
            UIViewController *VC = [self topViewController];
            [TJMHUDHandle hiddenHUDForView:VC.view];
            MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:VC.view message:payResult];
            [progressHUD hideAnimated:YES afterDelay:2.5];
        }
    }
}



@end
