//
//  TJMEntryCheckViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/10.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMEntryCheckViewController.h"
#import "TJMTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface TJMEntryCheckViewController ()<TDAlertViewDelegate>
{
    NSInteger _networkStatus;
    UIButton *_selectButton;
}
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeInfoViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeInfoViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeInfoBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstEnterImageHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondStepImageTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLesonImageTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitButtonHeightConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondStepImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLesonImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdStepImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstEnterImageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdEnterImageLeftConstraint;
//scrollView view height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;


//视图
@property (weak, nonatomic) IBOutlet UILabel *completeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *complRightNowLabel;

@property (weak, nonatomic) IBOutlet UILabel *studyOnLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *entryInspectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
//三个学习按钮
@property (weak, nonatomic) IBOutlet UIButton *lesonOneButton;
@property (weak, nonatomic) IBOutlet UIButton *lesonTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *lesonThreeButton;
//
@property (nonatomic,copy) NSArray *lesonButtonArray;
//视频学习资源
@property (nonatomic,strong) TJMStudyResource *studyResource;
//播放器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;

@end

@implementation TJMEntryCheckViewController
#pragma  mark - lazy loading
- (NSArray *)lesonButtonArray {
    if (!_lesonButtonArray) {
        self.lesonButtonArray = @[self.lesonOneButton,self.lesonTwoButton,self.lesonThreeButton];
    }
    return _lesonButtonArray;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"成为自由人" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
    [self networkObserver];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.35 animations:^{
        self.navBarBgAlpha = @"1.0";
    }];
    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:NO];
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
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.swipeBackEnabled = YES;
    }
}
- (void)viewDidLayoutSubviews {
    self.scrollViewHeightConstraint.constant = TJMScreenHeight - 64 + 1;
}
- (void)dealloc {
    //结束监听
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.completeInfoBottomConstraint,self.completeInfoViewHeightConstraint,self.completeInfoViewTopConstraint,self.firstStepImageHeightConstraint,self.firstLesonImageTopConstraint,self.firstEnterImageHeightConstraint,self.secondStepImageTopConstraint,self.commitButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.firstStepImageRightConstraint,self.secondStepImageRightConstraint,self.firstLesonImageRightConstraint,self.thirdEnterImageLeftConstraint,self.firstEnterImageLeftConstraint,self.thirdStepImageRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.completeInfoLabel,self.complRightNowLabel,self.studyOnLineLabel,self.entryInspectionLabel,self.answerLabel,self.checkLabel, nil];
}
- (void)configViews {
    // 切换账号按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = @"切换账号";
    [button setTitle:title forState:UIControlStateNormal];
    UIFont *font = [UIFont systemFontOfSize:15];
    button.frame = CGRectMake(0, 0, font.pointSize * title.length + 2, font.pointSize + 2);
    button.titleLabel.font = font;
    [button setTitleColor:TJMFUIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    //修改学习按钮状态
    [self configLesonButton];
}
- (void)configLesonButton {
    //根据自由人信息确定学习按钮状态
    NSInteger examStatus = self.freeManInfo.examStatus.integerValue;
    for (int i = 0; i < (examStatus > 3 ? 3 : examStatus); i ++) {
        UIButton *button = self.lesonButtonArray[i];
        button.selected = YES;
        
    }
}

#pragma  mark - 界面按钮方法
#pragma  mark 提交资料
- (IBAction)commitInfoAction:(UIButton *)sender {
    sender.enabled = NO;
    NSInteger materialStatus = self.freeManInfo.materialStatus.integerValue;
    if (materialStatus == 0 || materialStatus == 3) {
        //未提交 或者失败 进入
        [self performSegueWithIdentifier:@"CommitInfo" sender:self.freeManInfo];
    } else {
        //审核中 或者 已通过 不进入
        NSString *cueString = materialStatus == 1 ? @"资料审核中" : @"审核已通过";
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:cueString];
    }
    sender.enabled = YES;
}
#pragma  mark 三节学习按钮
- (IBAction)studyAction:(UIButton *)sender {
    TJMLog(@"%zd",sender.tag);
    sender.enabled = NO;
    _selectButton = sender;
    NSInteger materialStatus = self.freeManInfo.materialStatus.integerValue;
    //如果资料审核状态 为0：未提交 3：未通过 1：审核中
    if (materialStatus == 0 || materialStatus == 3 || materialStatus == 1) {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"审核未完成"];
        sender.enabled = YES;
        return;
    }
    NSInteger examStatus = self.freeManInfo.examStatus.integerValue;
    if (examStatus >= sender.tag - 100) {
        if (_networkStatus == 1) {
            //非wifi 环境 是否继续
            [self alertViewWithTag:10000 delegate:self title:@"非WIFI环境，是否继续" cancelItem:@"取消" sureItem:@"继续"];
            sender.enabled = YES;
        } else {
            [self studyWithButton:sender];
        }
    } else if (examStatus < sender.tag - 100) {
        //提示 请按顺序 学习
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请按顺序学习"];
        sender.enabled = YES;
    }
    
}

- (void)studyWithButton:(UIButton *)button {
    NSInteger examStatus = self.freeManInfo.examStatus.integerValue;
    //已学习过 或 按顺序学习
    //chapter 应比 examStatus 大 1
    NSString *chapter = [NSString stringWithFormat:@"%zd",examStatus + 1];
    [TJMRequestH getLearnResourceWithChapter:chapter success:^(id successObj, NSString *msg) {
        self.studyResource = successObj;
        [self performSegueWithIdentifier:@"GoToStudy" sender:self.studyResource];
        button.enabled = YES;
    } fail:^(NSString *failString) {
        button.enabled = YES;
    }];
}
#pragma  mark - 考试按钮
- (IBAction)examAction:(UIButton *)sender {
    NSInteger materialStatus = self.freeManInfo.materialStatus.integerValue;
    if (materialStatus == 0 || materialStatus == 3 || materialStatus == 1) {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"审核未完成"];
        return;
    }
    NSInteger examStatus = self.freeManInfo.examStatus.integerValue;
    if (examStatus == 3) {
        //可以进行考试
        [self performSegueWithIdentifier:@"GoToExam" sender:nil];
    } else if (examStatus < 3) {
        //请完成学习
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请先完成学习"];
    } else {
        //已完成考试 提交审核 成为自由人
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"考试已完成，提交审核，成为自由人吧！"];
    }
}
#pragma  mark - 成为自由人
- (IBAction)becomeFreeManAction:(UIButton *)sender {
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"提交中..."];
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            self.freeManInfo = successObj;
            if (_freeManInfo.examStatus.integerValue == 4 && _freeManInfo.materialStatus.integerValue == 2) {
                //审核通过，切换根视图
                //审核未通过
                progressHUD.label.text = @"恭喜您，已成为自由人";
                [progressHUD hideAnimated:YES afterDelay:1.5];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TJMTabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TJMTabBarController"];
                [self.appDelegate restoreRootViewController:tabBarVC];
            } else {
                NSString *noticeString;
                switch (_freeManInfo.materialStatus.integerValue) {
                    case 0:
                    {
                        noticeString = @"请完善资料";
                    }
                        break;
                    case 1:
                    {
                        noticeString = @"资料审核中";
                    }
                        break;
                    case 2:
                    {
                        noticeString = @"请完成学习及考试";
                    }
                        break;
                    case 3:
                    {
                        noticeString = @"资料审核未通过，请重新提交";
                    }
                        break;
                        
                    default:
                        break;
                }
                //审核未通过
                progressHUD.label.text = noticeString;
                [progressHUD hideAnimated:YES afterDelay:1.5];
            }
        } fail:^(NSString *failString) {
            
        }];
    }
    
}


#pragma  mark - TDAlertDelegate 
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        //网络状态提示 alert
        if (itemIndex == 0) {
            [self studyWithButton:_selectButton];
        }
    }
}

#pragma  mark - 切换账号
- (void)rightItemAction:(UIButton *)button {
    [self deleteCarrierInfo];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma  mark - 网络监测
- (void)networkObserver {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        _networkStatus = status;
    }];
    // 开始监控
    [mgr startMonitoring];
}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GoToStudy"]) {
        [segue.destinationViewController setValue:@(_selectButton.tag - 99) forKey:@"chapter"];
        [segue.destinationViewController setValue:sender forKey:@"studyResource"];
        NSString *title;
        if (self.studyResource.chapter.integerValue == 0) title = @"在线学习一";
        else if (self.studyResource.chapter.integerValue == 1) title = @"在线学习二";
        else if (self.studyResource.chapter.integerValue == 2) title = @"在线学习三";
        [segue.destinationViewController setValue:title forKey:@"myTitle"];
    } else if ([segue.identifier isEqualToString:@"CommitInfo"]) {
        [segue.destinationViewController setValue:sender forKey:@"freeManInfo"];
    }
}


@end
