//
//  TJMLoginViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *getMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *messageLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *secretLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetSecretButton;


@end
