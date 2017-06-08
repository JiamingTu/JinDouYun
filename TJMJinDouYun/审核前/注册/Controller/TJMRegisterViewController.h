//
//  TJMRegisterViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *getMessageButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *registerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic,copy) NSString *naviTitle;

@end
