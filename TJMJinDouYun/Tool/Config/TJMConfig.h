//
//  TJMConfig.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#ifndef TJMConfig_h
#define TJMConfig_h

//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//颜色
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//第三方APPKey等
//百度地图
#define TJMBaiduMapAK @"dMCzzquQYybYamac5VfEk7fVk0MRLp4b"
//极光推送
#define TJMJPushAppKey @"3b84de949bd1c8230a9198d4"
static NSString *JPushChannel = @"Publish channel";
// static BOOL JPushIsProduction = NO;
#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = NO;
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = YES;
#endif
//请求类实例
#define TJMRequestH [TJMRequestHandle shareRequestHandle]
#define TJMAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate
//获取时间戳
#define TJMTimestamp [NSString stringWithFormat:@"%ld",time(NULL)*1000]

// 日志输出
#ifdef DEBUG // 开发阶段-DEBUG阶段:使用Log
#define TJMLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段-上线阶段:移除Log
#define TJMLog(...)
#endif


#endif /* TJMConfig_h */
