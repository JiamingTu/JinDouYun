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
    BOOL ret = [_mapManager start:BaiduMapAK  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
#pragma  mark 关闭引擎
- (void)stopBaiduMapEngine {
    BOOL ret = [_mapManager stop];
    if (!ret) {
        NSLog(@"manager stop failed!");
    }
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
- (void)onGetPermissionState:(int)iError {
    if (iError == 0) {
        NSLog(@"验证成功");
    }else {
        NSLog(@"验证失败,%d",iError);
    }
}

#pragma  mark - 配置百度地图导航
#pragma  mari 初始化
- (void)startBaiduMapNaviServicesWithResult:(ResultBlock)result {
    //初始化导航SDK
    /**
     *  初始化服务，需要在AppDelegate的 application:didFinishLaunchingWithOptions:
     *  中调用
     *
     *  @param ak AppKey
     */
    [BNCoreServices_Instance initServices:BaiduMapAK];
    /**
     *  启动服务,异步方法
     *
     *  @param success 启动成功后回调 success block
     *  @param fail    启动失败后回调 fail block
     */
    [BNCoreServices_Instance startServicesAsyn:^{
        
        result();
#warning  异步开启成功后需要回调 然后开始导航
    } fail:^{
        NSLog(@"异步开启失败");
    }];
    /**
     *  启动服务,同步方法,会导致阻塞
     *
     *  @return  启动结果
     */
    //    [BNCoreServices_Instance startServices];
}
#pragma  mark 终止服务
- (void)stopBaiduMapNaviServices {
    [BNCoreServices_Instance stopServices];
}








@end
