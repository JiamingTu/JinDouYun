//
//  AppDelegate+APPService.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate+APPService.h"

@implementation AppDelegate (APPService)

- (void)checkLoggingStatusWithToken {
    if ([TJMSandBoxManager getTokenModel]) {
        //token 存在 进入首页
        NSLog(@"token存在 确认登录");
    }else {
        //token 进入未登录页面 UIStoryboard
        NSLog(@"token 不存在");
    }
}


@end
