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
#define TJMScreenWidth [UIScreen mainScreen].bounds.size.width
#define TJMScreenHeight [UIScreen mainScreen].bounds.size.height

#define TJMWidthRatio [UIScreen mainScreen].bounds.size.width / 375.0
#define TJMHeightRatio [UIScreen mainScreen].bounds.size.height / 667.0
//版本
#define TJMCurrentDevice [[[UIDevice currentDevice] systemVersion] floatValue]


//颜色
#define TJMRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TJMRGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define TJMFUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//appkey 等
#import "TJMAppKey.h"

//YYKeyboard
#define TJMYYKeyboardManager [YYKeyboardManager defaultManager]


//请求类实例
#define TJMRequestH [TJMRequestHandle sharedRequestHandle]
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
