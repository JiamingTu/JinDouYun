//
//  AppDelegate.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJMFreeManInfo;

@class AppDelegate;
typedef void(^WorkTimeBlock)();
typedef void(^ResultBlock)(BOOL isOK);
typedef NSString *(^SignInBlock)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) WorkTimeBlock workTimeBlock;
@property (nonatomic,copy) WorkTimeBlock stopTimer;
@property (nonatomic,strong) TJMFreeManInfo *freeManInfo;


@end

