//
//  TJMMineViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMMineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *myWalletLabel;
@property (weak, nonatomic) IBOutlet UILabel *emergencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutOursLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;

@property (weak, nonatomic) IBOutlet UIButton *headerButton;


@end
