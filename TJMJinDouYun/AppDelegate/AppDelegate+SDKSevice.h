//
//  AppDelegate+SDKSevice.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (SDKSevice)<BMKGeneralDelegate>

/*
 *启动百度地图引擎
 *
 */
- (void)startBaiduMapEngine;

/*
 *终止百度地图引擎
 *
 */
- (void)stopBaiduMapEngine;

/*
 *启动百度地图导航模块
 *
 */
- (void)startBaiduMapNaviServicesWithResult:(ResultBlock)result;
/*
 *终止百度地图导航模块
 *
 */
- (void)stopBaiduMapNaviServices;

@end
