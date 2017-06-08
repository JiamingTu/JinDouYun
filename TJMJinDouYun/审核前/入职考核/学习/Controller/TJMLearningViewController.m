//
//  TJMLearningViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/26.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMLearningViewController.h"
#import "TJMEntryCheckViewController.h"
#import "ZGLVideoPlyer.h"
@interface TJMLearningViewController ()<TDAlertViewDelegate,ZGLVideoPlayerDelegate>

@property (nonatomic,strong) ZGLVideoPlyer *player;
@end

@implementation TJMLearningViewController
#pragma  mark - lazy loading
- (ZGLVideoPlyer *)player {
    if (!_player) {
        self.player = [[ZGLVideoPlyer alloc]initWithFrame:self.view.bounds];
        self.player.backgroundColor = [UIColor blackColor];
        self.player.videoUrlStr = self.studyResource.resourceUrl;
        self.player.delegate = self;
    }
    return _player;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:self.myTitle fontSize:17 colorHexValue:0x333333];
    [self.view addSubview:self.player];
    [self setBackNaviItem];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.swipeBackEnabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma  mark - 按钮绑定
- (void)itemAction:(UIButton *)button {
    //相当于点击了已学习过的按钮
    if (self.studyResource.chapter != self.chapter) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //视频尚未播放完成 是否退出
    if (self.player.currentPlayTime < self.player.totalTime - 5) {
        [self.player pause];
        [self alertViewWithTag:10000 delegate:self title:@"学习未完成，是否退出" cancelItem:@"退出" sureItem:@"继续观看"];
    } else if (self.player.totalTime == 0) {
        //视频尚未缓冲完毕
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self playerDidPlayToEndTime];
    }
    
}


#pragma  mark - ZGLVideoPlayerDelegate
- (void)fullScreenStatus:(BOOL)isFullScreen {
    self.navigationController.navigationBarHidden = isFullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:isFullScreen];
}

- (void)playerDidPlayToEndTime {
    //相当于点击了已学习过的按钮
    if (self.studyResource.chapter != self.chapter) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //播放完毕 请求 + pop
    [TJMRequestH passExamWithChapter:self.studyResource.chapter.description success:^(id successObj, NSString *msg) {
        //请求成功
        TJMEntryCheckViewController *entryCheckVC = [self popTargetViewControllerWithViewControllerNumber:1];
        entryCheckVC.freeManInfo.examStatus = self.studyResource.chapter;
        [entryCheckVC configLesonButton];
        [self.navigationController popToViewController:entryCheckVC animated:YES];
    } fail:^(NSString *failString) {
        
    }];
}

#pragma  mark - TDAlertViewDelegate
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        //点击播放完成按钮 后
        if (itemIndex == 0) {
            [self.player play];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
