//
//  TJMChangePasswordViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMChangePasswordViewController.h"

@interface TJMChangePasswordViewController ()<UITextFieldDelegate>
{
    NSInteger _count;
}
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeVIewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLineViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeButtonHeightConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freshPwdLabelConstraint;
//
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *freshPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *freshPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *sureFreshPwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *sureFreshPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
//
@property (nonatomic,strong) NSTimer *countDownTimer;

@property (nonatomic,copy) NSString *phoneNum;

@end

@implementation TJMChangePasswordViewController
#pragma  mark - lazy loading

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"修改密码" fontSize:17 colorHexValue:0x333333];
    //增加监听
    [self.appDelegate getFreeManInfoWithViewController:self fail:^(NSString *failMsg) {
        
    }];
    [self configViews];
}
- (void)dealloc {
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    //移除监听
    [self.appDelegate removeFreeManInfoWithViewController:self];
    
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.noticeVIewHeightConstraint,self.codeImageHeightConstraint,self.firstLineViewTopConstraint,self.firstLineViewBottomConstraint,self.secondLineViewBottomConstraint,self.codeButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.codeImageHeightConstraint,self.noticeImageRightConstraint,self.freshPwdLabelConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:12 forView:self.noticeLabel, nil];
    [self tjm_adjustFont:15 forView:self.freshPwdLabel,self.freshPwdTextField,self.sureFreshPwdLabel,self.sureFreshPwdTextField, nil];
    [self tjm_adjustFont:14 forView:self.codeButton, nil];
}
- (void)configViews {
    [self setBackNaviItem];
    [self setRightNaviItemWithImageName:nil orTitle:@"保存" titleColorHexValue:0x333333 fontSize:15];
}
#pragma  mark - 按钮/定时器 方法
#pragma  mark 获取验证码
- (IBAction)getCode:(UIButton *)sender {
    [sender setTitle:@"59秒" forState:UIControlStateDisabled];
    sender.enabled = NO;
    _count = 59;
    if (!self.countDownTimer) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    }
    if (self.phoneNum) {
        [TJMRequestH shrotMessageCheckRequestWithPhoneNumber:self.phoneNum getCodeType:TJMGetForgetSecretCode success:^(id successObj, NSString *msg) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:msg];
        } fail:^(NSString *failString) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:failString];
        }];
    }
    
}
- (void)rightItemAction:(UIButton *)button {
    if (self.codeTextField.text.length == 6) {
        if ([self.freshPwdTextField.text isEqualToString:self.sureFreshPwdTextField.text]) {
            if (self.freshPwdTextField.text.length >= 6) {
                NSDictionary *parameters = @{@"mobile":self.phoneNum,@"pwd":self.sureFreshPwdTextField.text,@"code":self.codeTextField.text};
                [TJMRequestH accountCheckWithForm:parameters checkType:TJMChageSecret success:^(id successObj, NSString *msg) {
                    [TJMHUDHandle transientNoticeAtView:self.view withMessage:msg];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } fail:^(NSString *failString) {
                    
                }];
            } else {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"不少于6位"];
            }
        } else {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"输入的密码不一致"];
        }
    } else {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"验证码不足6位"];
    }
}
#pragma  mark 定时器方法
- (void)countDown {
    _count --;
    NSString *title = [NSString stringWithFormat:@"%zd秒",_count];
    [self.codeButton setTitle:title forState:UIControlStateDisabled];
    if (_count == 0) {
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal
         ];
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        self.codeButton.enabled = YES;
    }
}
#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [textField.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];

    //密码输入框
    if ([textField isEqual:self.freshPwdTextField] || [textField isEqual:self.sureFreshPwdTextField]) {
        //如果是中文 则不允许输入
        if ([string isChinese]) {
            return NO;
        } else if ([newValue containsString:@" "]) {
            return NO;
        }
    }
    //验证码输入框
    if ([textField isEqual:self.codeTextField]) {
        //判断是否6位的数字 大于6位则不可再输入
        if ([newValue length] > 6 || ![newValue isNumber]) {
            return NO;
        }
    }
    return YES;
}

#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kKVOFreeManInfo]) {
        TJMFreeManInfo *model = change[@"new"];
        self.phoneNum = model.mobile.description;
        NSString *starPhoneNum = [self.phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.noticeLabel.text = [NSString stringWithFormat:@"温馨提示：为了验证您的身份，需向%@发送一条验证码，请点击获取按钮后输入验证码",starPhoneNum];
    }
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
