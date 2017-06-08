//
//  TJMDeliveryPayViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMDeliveryPayViewController.h"

@interface TJMDeliveryPayViewController ()
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpPayButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpPayButtonHeightConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelRightConstraint;

//
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *canNotPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpPayButton;


@end

@implementation TJMDeliveryPayViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.QRCodeImageTopConstraint,self.QRCodeImageHeightConstraint,self.QRCodeImageBottomConstraint,self.orLabelBottomConstraint,self.helpPayButtonTopConstraint,self.helpPayButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.orLabelLeftConstraint,self.orLabelRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.orLabel, nil];
    [self tjm_adjustFont:12 forView:self.canNotPayLabel,self.helpPayLabel, nil];
    [self tjm_adjustFont:18 forView:self.helpPayButton, nil];
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
