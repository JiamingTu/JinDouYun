//
//  AppDelegate.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CallBlock)();

typedef void(^ResultBlock)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

//开启、关闭百度地图引擎
@property (nonatomic,copy) CallBlock InitBaiduMapEngine;

//开启、关闭导航模块
@property (nonatomic,copy) CallBlock InitNaviServices;
@property (nonatomic,copy) CallBlock StopNaviServices;
//调用此block后 在地图页面开启导航
@property (nonatomic,copy) ResultBlock GetResult;

@end

