//
//  TJMHomepageViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/18.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMHomepageViewController : UIViewController
@property (nonatomic,strong) UIButton *naviLeftButton;

//storyboard
//label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *todayEarningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;


//button
@property (weak, nonatomic) IBOutlet UIButton *workButton;
@property (weak, nonatomic) IBOutlet UIButton *rabOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *waitFetchButton;
@property (weak, nonatomic) IBOutlet UIButton *waitSendButton;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//开工时间定时器
@property (nonatomic, strong) NSThread *timerThread;
@property (nonatomic,strong) NSTimer *workingTimeTimer;
@property (nonatomic,assign) NSInteger currentTimestamp;

//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imaginaryLineViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonCutLineHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleCutLineHeightConstraint;
//抢单等按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalMoneyLabelHeightConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageRightConstraint;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineViewLeft;

- (void)reloadOrderList;

@end
