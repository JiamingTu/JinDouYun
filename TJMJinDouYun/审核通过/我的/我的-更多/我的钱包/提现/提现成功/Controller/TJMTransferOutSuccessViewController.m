//
//  TJMTransferOutSuccessViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTransferOutSuccessViewController.h"
#import "TJMTransferOutViewController.h"
@interface TJMTransferOutSuccessViewController ()

//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewTopConstraint;


//
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;






@end

@implementation TJMTransferOutSuccessViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"提现" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
}

#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.imageViewTopConstraint,self.imageViewHeightConstraint,self.imageViewBottomConstraint,self.noticeLabelBottomConstraint,self.bankCardLabelTopConstraint,self.bankCardLabelBottomConstraint,self.bottomLineViewTopConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:18 forView:self.noticeLabel, nil];
    [self tjm_adjustFont:14 forView:self.bankCardLabel,self.bankCardNameLabel,self.cashMoneyLabel,self.moneyLabel, nil];
}
- (void)configViews {
    //设置提现金额label
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.money];
    //设置银行卡label
    NSString *bankName = self.bankCardModel.bank.bankName;
    NSString *bankCardNum = self.bankCardModel.bankcard.description;
    NSString *lastFout = [bankCardNum substringFromIndex:bankCardNum.length - 4];
    self.bankCardNameLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",bankName,lastFout];
    //设置 左导航按钮
    [self setBackNaviItem];
    
    
}
- (void)itemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - memory warning;
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
