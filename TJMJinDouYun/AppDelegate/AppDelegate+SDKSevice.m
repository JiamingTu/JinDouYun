//
//  AppDelegate+SDKSevice.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate+SDKSevice.h"

@implementation AppDelegate (SDKSevice)

#pragma  mark - 配置百度地图
#pragma  mark 打开引擎
- (void)startBaiduMapEngine {
    //在您的AppDelegate.m文件中添加对BMKMapManager的初始化，并填入您申请的授权Key
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:TJMBaiduMapAK  generalDelegate:self];
    if (!ret) {
        TJMLog(@"manager start failed!");
    }
}
#pragma  mark 关闭引擎
- (void)stopBaiduMapEngine {
    BOOL ret = [_mapManager stop];
    if (!ret) {
        TJMLog(@"manager stop failed!");
    }
}
#pragma mark BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError {
    if (iError == 0) {
        TJMLog(@"网络正常");
    }else {
        TJMLog(@"网络出错,%@",@(iError));
    }
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参考BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError {
    if (iError == 0) {
        TJMLog(@"验证成功");
    }else {
        TJMLog(@"验证失败,%d",iError);
    }
}

#pragma  mark - 配置百度地图导航
#pragma  mari 初始化
- (void)startBaiduMapNaviServicesWithResult:(ResultBlock)result {
    //初始化导航SDK
    //初始化服务，需要在AppDelegate的 application:didFinishLaunchingWithOptions:
    //中调用

    [BNCoreServices_Instance initServices:TJMBaiduMapAK];
    // 启动服务,异步方法

    [BNCoreServices_Instance startServicesAsyn:^{
        
        result(YES);
#warning  异步开启成功后需要回调 然后开始导航
    } fail:^{
        result(NO);
    }];
     //启动服务,同步方法,会导致阻塞
//    [BNCoreServices_Instance startServices];
}
#pragma  mark 终止服务
- (void)stopBaiduMapNaviServices {
    [BNCoreServices_Instance stopServices];
}



#pragma  mark - 极光推送
#pragma  mark 注册
- (void)registerJPush {
    // 注册apns通知 // iOS10
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else // iOS7
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
#endif
    }


}
#pragma  mark - 初始化
- (void)startJPushWithLaunchOptions:(NSDictionary *)launchOptions {
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:TJMJPushAppKey
                          channel:JPushChannel
                 apsForProduction:JPushIsProduction];
}

#pragma mark JPUSHRegisterDelegate 和 旧版本回调
//以下代理方法只有在点击推送消息后才会调用
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        TJMLog(@"%@",userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        TJMLog(@"%@",userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    TJMLog(@"%@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    TJMLog(@"%@",userInfo);
}



@end
