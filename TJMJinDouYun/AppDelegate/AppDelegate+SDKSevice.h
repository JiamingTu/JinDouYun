//
//  AppDelegate+SDKSevice.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (SDKSevice)<JPUSHRegisterDelegate>
//百度地图
/**启动百度地图导航模块*/
- (void)startBaiduMapNaviServicesWithResult:(ResultBlock)result;
/**终止百度地图导航模块*/
- (void)stopBaiduMapNaviServices;
//极光推送
/**注册*/
- (void)registerJPush;
/**设置别名*/
- (void)setAlias;
/**初始化*/
- (void)startJPushWithLaunchOptions:(NSDictionary *)launchOptions;

/**百度地图鹰眼*/
- (BOOL)initTraceService;

@end
