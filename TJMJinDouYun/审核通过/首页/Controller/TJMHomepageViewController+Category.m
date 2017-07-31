//
//  TJMHomepageViewController+Category.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/9.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomepageViewController+Category.h"

@implementation TJMHomepageViewController (Category)
#pragma  mark - 页面配置

//约束
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.headerImageTopConstraint,self.headerImageHeightConstraint,self.workButtonTopConstraint,self.workButtonHeightConstraint,self.earningsImageTopConstraint,self.earningsImageHeightConstraint,self.earningsImageBottomConstraint,self.workTimeImageHeightConstraint,self.imaginaryLineViewTopConstraint,self.buttonCutLineHeightConstraint,self.middleCutLineHeightConstraint,self.buttonHeightConstraint,self.totalMoneyLabelHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.nameLabelLeftConstraint,self.workTimeImageRightConstraint,self.earningsImageRightConstraint, nil];
}
//设置字体
- (void)adjustFonts {
    [self tjm_adjustFont:16 forView:self.nameLabel, nil];
    [self tjm_adjustFont:13 forView:self.currentStatusLabel,self.statusLabel, nil];
    [self tjm_adjustFont:18 forView:self.workButton, nil];
    [self tjm_adjustFont:12 forView:self.todayEarningsLabel,self.workTimeLabel, nil];
    [self tjm_adjustFont:15 forView:self.totalTimeLabel,self.totalMoneyLabel,self.rabOrderButton,self.waitFetchButton,self.waitSendButton, nil];
}

#pragma  mark 开启、关闭 鹰眼
- (void)configbaiduTraceWithWorkStatus:(BOOL)workStatus {
    BOOL result = [self.appDelegate initTraceService];
    if (workStatus && result) {
        TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
        // 设置开启轨迹服务时的服务选项，指定本次服务以“entityA”的名义开启
        BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:tokenModel.userId.description];
        // 开启服务
        [[BTKAction sharedInstance] startService:op delegate:self];
    } else {
        [[BTKAction sharedInstance] stopService:self];
    }
}
- (void)onStartService:(BTKServiceErrorCode)error {
    if (error == BTK_START_SERVICE_SUCCESS) {
        [[BTKAction sharedInstance] startGather:self];
    }
}
- (void)onStopService:(BTKServiceErrorCode)error {
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
        [[BTKAction sharedInstance] stopGather:self];
    }
}
- (void)onStartGather:(BTKGatherErrorCode)error {
    
}
- (void)onStopGather:(BTKGatherErrorCode)error {
    
}

#pragma  mark - timer
#pragma  mark 开启定时器
- (void)startTimerWithTimestamp:(NSInteger)timestamp {
    //如果从服务器获取的时间改了 赋值还是要赋的
    self.currentTimestamp = 86390;
    //如果timer还存在（没有停止），那就不重新创建子线程 和 timer 了
    if (!self.workingTimeTimer) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.timerThread = [NSThread currentThread];
                [strongSelf.timerThread setName:@"timerThread"];
                strongSelf.workingTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:strongSelf selector:@selector(timerAction:) userInfo: nil repeats:YES];
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:strongSelf.workingTimeTimer forMode:NSDefaultRunLoopMode];
                [runloop run];
            }
        });
    }
}
#pragma  mark 定时器绑定方法
- (void)timerAction:(NSTimer *)timer {
    //继续在分线程中计算 时间
    self.currentTimestamp += 1;
    NSString *timeString = [self tjm_getTimeStringWithTimestamp:self.currentTimestamp];
    //返回主线程
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.totalTimeLabel.text = timeString;
    }];
}
#pragma  mark 销毁定时器
- (void)cancel{
    if (self.workingTimeTimer) {
        [self.workingTimeTimer invalidate];
        self.workingTimeTimer = nil;
    }
}
//需在开启的线程中销毁
- (void)cancelTiemr {
    if (self.workingTimeTimer && self.timerThread) {
        [self performSelector:@selector(cancel) onThread:self.timerThread withObject:nil waitUntilDone:YES];
    }
}

#pragma  mark - 上传定位






@end
