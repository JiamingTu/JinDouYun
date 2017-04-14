//
//  TJMRegisterViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMRegisterViewController.h"
#import <MBProgressHUD.h>
@interface TJMRegisterViewController ()<UITextFieldDelegate>
{
    CGFloat _countDownTime;
}
@property (nonatomic,strong) NSTimer *countDownTimer;

@end

@implementation TJMRegisterViewController
#pragma  mark - lazy loading
- (NSTimer *)countDownTimer {
    if (!_countDownTimer) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
        _countDownTime = 59;
    }
    return _countDownTimer;
}
#pragma  mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

#pragma  mark - 添加通知
#pragma  mark textField 通知

#pragma  mark - 界面按钮方法
- (IBAction)getShortMessageAction:(UIButton *)sender {
    //判断是否是手机号
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //获取验证码按钮进入倒计时
        [self countDownTimer];
        [sender setTitle:@"59秒后再次获取" forState:UIControlStateNormal];
        sender.enabled = NO;
        //请求验证码
        [TJMRRequestH shrotMessageCheckRequestWithPhoneNumber:_phoneNumberTF.text getCodeType:TJMGetRegisterCode success:^(id successObj) {
            
        } fail:^(NSString *failString) {
            
        }];
    } else {
        NSLog(@"请输入正确的手机号");
    }
    
    
}
- (IBAction)registerAction:(UIButton *)sender {
    //判断是否电话号码
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //至少6位密码
        if (self.passwordTF.text.length >= 6) {
            //验证码不少于6位
            if (self.authCodeTF.text.length <= 6) {
                //提交表单
                NSDictionary *form = @{@"mobile":_phoneNumberTF.text,@"pwd":_passwordTF.text,@"code":_authCodeTF.text};
                [TJMRRequestH accountCheckWithForm:form checkType:TJMRegister success:^(id successObj) {
                    
                } fail:^(NSString *failString) {
                    
                }];
//验证码登录
//              NSDictionary *form = @{@"mobile":_phoneNumberTF.text,@"code":_authCodeTF.text};
//                [TJMRRequestH accountCheckWithForm:form checkType:TJMCodeLogin success:^(id successObj) {
//                    
//                } fail:^(NSString *failString) {
//                    
//                }];
                
                
            }else {
                NSLog(@"验证码不足6位");
            }
        }else {
            NSLog(@"密码不能少于6位");
        }
    }else {
        NSLog(@"请输入正确的手机号");
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请输入正确的手机号"];
    }
    
    
}


#pragma  mark - 定时器
- (void)countDownAction {
    _countDownTime--;
    NSString *title = [NSString stringWithFormat:@"%.0f秒后再次获取",_countDownTime];
    [self.getMessageButton setTitle:title forState:UIControlStateNormal];
    if (_countDownTime == 0) {
        [self.getMessageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        if (_phoneNumberTF.text.length < 11) {
            _getMessageButton.enabled = NO;
        }else {
            _getMessageButton.enabled = YES;
        }
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [textField.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    //电话号码输入框
    if ([textField isEqual:self.phoneNumberTF]) {
        //判断是否11位 不到验证码按钮不可用
        if ([newValue length] <= 10 && [newValue isNumber]) {
            self.getMessageButton.enabled = NO;
        }
        else if (newValue.length == 11 && [newValue isNumber]){
            self.getMessageButton.enabled = YES;
        }else {
            return NO;
        }
    }
    //密码输入框
    if ([textField isEqual:self.passwordTF]) {
        //如果是中文 则不允许输入
        if ([string isChinese]) {
            return NO;
        } else if ([newValue containsString:@" "]) {
            return NO;
        }
    }
    //验证码输入框
    if ([textField isEqual:self.authCodeTF]) {
        //判断是否6位的数字 大于6位则不可再输入
        if ([newValue length] > 6 || ![newValue isNumber]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - dealloc 
- (void)dealloc {
    [_countDownTimer invalidate];
    _countDownTimer = nil;
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
