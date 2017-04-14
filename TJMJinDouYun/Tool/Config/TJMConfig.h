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

//第三方APPKey
#define BaiduMapAK @"dMCzzquQYybYamac5VfEk7fVk0MRLp4b"

//请求类实例
#define TJMRRequestH [TJMRequestHandle shareRequestHandle]

//获取时间戳
#define TJMTimestamp [NSString stringWithFormat:@"%ld",time(NULL)*1000]



#endif /* TJMConfig_h */
