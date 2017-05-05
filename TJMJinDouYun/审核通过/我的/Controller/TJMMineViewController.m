//
//  TJMMineViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMineViewController.h"
#import "TJMMineTableViewCell.h"

@interface TJMMineViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *naviBgView;

//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateValueLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateValueLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateValuLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSectionHeightConstraint;


//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myOrderImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myWalletImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myEvaluateImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emergencyImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutOursImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingImageHeightConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myOrderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myWalletConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myEvaluateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emergencyCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutOursConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingConstraint;





@end

@implementation TJMMineViewController
#pragma  mark - lazy loading

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的" fontSize:17 colorHexValue:0x333333];
    self.naviBgView.backgroundColor = [UIColor whiteColor];
    
    [self adjustFonts];
    [self resetConstraints];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    UIImage *image = [self createImageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:image];
    self.navBarBgAlpha = @"0.0";

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollViewContentHeightConstraint.constant = CGRectGetMaxY(self.settingView.frame) + 20;
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self resetVerticalConstraints:self.headerImageTopConstraint,self.headerImageHeightConstraint,self.headerImageBottomConstraint,self.nameLabelHeightConstraint,self.nameLabelHeightConstraint,self.phoneNumLabelBottomConstraint,self.phoneNumLabelHeightConstraint,self.evaluateValueLabelTopConstraint,self.evaluateValueLabelHeightConstraint,self.evaluateValuLabelBottomConstraint,self.evaluateValueLabelHeightConstraint,self.evaluateLabelBottomConstraint,self.cellHeightConstraint,self.myOrderImageHeightConstraint,self.myWalletImageHeightConstraint,self.myEvaluateImageHeightConstraint,self.emergencyImageHeightConstraint,self.aboutOursImageHeightConstraint,self.settingImageHeightConstraint,self.firstSectionHeightConstraint,self.secondSectionHeightConstraint, nil];
    [self resetHorizontalConstraints:self.myOrderConstraint,self.myWalletConstraint,self.myEvaluateConstraint,self.emergencyCenterConstraint,self.aboutOursConstraint,self.settingConstraint, nil];
}
- (void)adjustFonts {
    [self adjustFont:16 forView:self.nameLabel, nil];
    [self adjustFont:13 forView:self.phoneNumLabel, nil];
    [self adjustFont:20 forView:self.evaluateValueLabel,self.totalOrderNumLabel, nil];
    [self adjustFont:15 forView:self.evaluateLabel,self.totalOrderLabel,self.myOrderLabel,self.myWalletLabel,self.myEvaluateLabel,self.emergencyLabel,self.aboutOursLabel,self.settingLabel, nil];
}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
