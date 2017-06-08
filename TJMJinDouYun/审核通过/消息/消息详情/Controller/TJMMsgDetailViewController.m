//
//  TJMMsgDetailViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMsgDetailViewController.h"

@interface TJMMsgDetailViewController ()
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewBottomConstraint;




@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation TJMMsgDetailViewController

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息详情" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self configViews];
}
#pragma  mark - 页面设置
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.titleLabelTopConstraint,self.titleLabelBottomConstraint,self.lineViewTopConstraint,self.lineViewBottomConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:16 forView:self.titleLabel, nil];
    [self tjm_adjustFont:12 forView:self.dateLabel, nil];
    [self tjm_adjustFont:14 forView:self.detailTextView, nil];
}
- (void)configViews {
    [self setBackNaviItem];
    self.dateLabel.text = [NSString getTimeWithTimestamp:self.messageModel.updateTime formatterStr:@"MM-dd HH:mm"];
    self.detailTextView.text = self.messageModel.content;
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
