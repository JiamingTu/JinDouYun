//
//  AppDelegate+SDKSevice.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate+SDKSevice.h"
@implementation AppDelegate (SDKSevice)



#pragma  mark - 配置百度地图导航
#pragma  mari 初始化
- (void)startBaiduMapNaviServicesWithResult:(ResultBlock)result {
    //初始化导航SDK
    //初始化服务，需要在AppDelegate的 application:didFinishLaunchingWithOptions:
    //中调用
    [BNCoreServices_Instance initServices:TJMBaiduMapAK];
    // 启动服务,同步方法
    [BNCoreServices_Instance startServicesAsyn:^{
        result(YES);
    } fail:^{
        result(NO);
    }];
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
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        //TJMLog(@"+++++++++rescode: %d, \nregistrationID: %@, ", resCode, registrationID);
        if ([TJMSandBoxManager getTokenModel]) {
            [self setAlias];
        }
        
    }];
}

#pragma  mark 设置别名
- (void)setAlias {
    NSNumber *userId = [TJMSandBoxManager getTokenModel].userId;
    [JPUSHService setTags:nil alias:userId.description fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        TJMLog(@"+++++++++rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
}
#pragma  mark 初始化
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
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


#pragma  mark 自定义消息回调
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSInteger type = [extras[@"type"] integerValue];
    if (type == 0) {
        //签收成功
        
        [self receivedSignInMessageWithBlock:^NSString *{
            return content;
        }];
    }
}


#pragma mark JPUSH 回调
//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    //前台通知需要弹框处理
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    TJMLog(@"%@",userInfo);
}

#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        TJMLog(@"%@",userInfo);
    }
    else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support 收到通知 点击后
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        TJMLog(@"%@",userInfo);
    }
    else {
        // 本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma  mark - 百度鹰眼
- (BOOL)initTraceService {
    //百度鹰眼
    NSString *mCode = [[NSBundle mainBundle] bundleIdentifier];
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:TJMBaiduMapAK mcode:mCode serviceID:TJMBaiduTraceServiceID keepAlive:true];
    return [[BTKAction sharedInstance] initInfo:sop];
}


@end
