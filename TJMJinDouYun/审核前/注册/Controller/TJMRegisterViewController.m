//
//  TJMRegisterViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMRegisterViewController.h"
#import <MBProgressHUD.h>
@interface TJMRegisterViewController ()<UITextFieldDelegate,YYKeyboardObserver>
{
    NSInteger _countDownTime;
    CGFloat _offsetHeight;
    CGFloat _keyboardHeight;
    NSString *_requestType;
}
@property (nonatomic,strong) NSTimer *countDownTimer;
//约束
//竖直的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLineTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLineBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswdLineTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswdLineBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLineTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLineBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnBottomConstraint;
//水平的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageConstraint;

//视图
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;



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
#pragma  mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:self.naviTitle fontSize:17 colorHexValue:0x333333];
    //设置请求类别
    if ([self.naviTitle isEqualToString:@"注册"]) {
        _requestType = TJMRegister;
    } else {
        _requestType = TJMChageSecret;
    }

    [self adjustFonts];
    [self resetConstrains];
    [self configSubviews];
    
    //键盘监听
    [TJMYYKeyboardManager addObserver:self];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _offsetHeight = self.view.frame.size.height - CGRectGetMaxY(self.mainView.frame);
}
- (void)dealloc {
    //移除监听
    [TJMYYKeyboardManager removeObserver:self];
    //清空定时器
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

#pragma  mark - 界面配置
- (void)resetConstrains{
    [self tjm_resetVerticalConstraints:self.userImageTopConstraint,self.userLineTopConstraint,self.userLineBottomConstraint,self.pswdLineTopConstraint,self.pswdLineBottomConstraint,self.msgLineTopConstraint,self.msgLineBottomConstraint,self.getMsgBtnTopConstraint,self.getMsgBtnBottomConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.bgImageConstraint, nil];
}
- (void)configSubviews {
    //设置阴影
    [self setShadowWithView:self.shadowView shadowColor:TJMFUIColorFromRGB(0xffdf22)];
    //设置返回按钮
    [self setBackNaviItem];
    self.titleNameLabel.text = [self.naviTitle isEqualToString:@"注册"] ? @"用户注册" : @"忘记密码";
    NSString *commitButtonTitle = [self.naviTitle isEqualToString:@"注册"] ? @"注 册" : @"修改密码";
    [self.commitButton setTitle:commitButtonTitle forState:UIControlStateNormal];
    
    
    
}
- (void)adjustFonts {
    //设置字体
    [self tjm_adjustFont:14 forView:self.getMessageButton,self.registerTitleLabel,self.passwordTF,self.phoneNumberTF,self.authCodeTF,self.getMessageButton, nil];
    [self tjm_adjustFont:18 forView:self.registerButton, nil];
}



#pragma  mark - 界面按钮方法
- (IBAction)getShortMessageAction:(UIButton *)sender {
    //判断是否是手机号
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //获取验证码按钮进入倒计时
        [self countDownTimer];
        [sender setTitle:@"59秒" forState:UIControlStateDisabled];
        sender.enabled = NO;
        //请求验证码
        NSString *getCodeType = [_requestType isEqualToString:TJMRegister] ? TJMGetRegisterCode : TJMGetForgetSecretCode;
        [TJMRequestH shrotMessageCheckRequestWithPhoneNumber:_phoneNumberTF.text getCodeType:getCodeType success:^(id successObj,NSString *msg) {
            
        } fail:^(NSString *failString) {
            
        }];
    } else {
        TJMLog(@"请输入正确的手机号");
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
                NSDictionary *form = @{@"mobile":_phoneNumberTF.text,@"pwd":[_passwordTF.text MD5],@"code":_authCodeTF.text};
                [TJMRequestH accountCheckWithForm:form checkType:_requestType success:^(id successObj,NSString *msg) {
                    
                } fail:^(NSString *failString) {
                    
                }];
                
            }else {
                TJMLog(@"验证码不足6位");
            }
        }else {
            TJMLog(@"密码不能少于6位");
        }
    }else {
        TJMLog(@"请输入正确的手机号");
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请输入正确的手机号"];
    }
    
    
}
#pragma  mark - 键盘监听
- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    
    CGRect stratRect = transition.fromFrame;
    CGRect endRect = transition.toFrame;
    

    if (transition.toVisible) {
        //弹出
        //如果起始位置是屏幕外 才执行
        if (stratRect.origin.y == TJMScreenHeight) {
            CGFloat kbHeight = endRect.size.height;
            [UIView animateWithDuration:transition.animationDuration delay:.0f options:transition.animationOption animations:^{
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y - kbHeight + _offsetHeight);
            } completion:^(BOOL finished) {
                
            }];
            //记录键盘高度
            _keyboardHeight = endRect.size.height;
        } else if (_keyboardHeight != endRect.size.height && (stratRect.origin.y - endRect.origin.y > 0)) {
            //键盘高度有变化
            [UIView animateWithDuration:transition.animationDuration delay:.0f options:transition.animationOption animations:^{
                CGFloat offsetKeyboardHeight = _keyboardHeight - endRect.size.height;
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y + offsetKeyboardHeight);
            } completion:^(BOOL finished) {
                _keyboardHeight = endRect.size.height;
            }];
        }
    } else {
        //收起
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
            
            self.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma  mark - 定时器
- (void)countDownAction {
    _countDownTime--;
    NSString *title = [NSString stringWithFormat:@"%zd秒",_countDownTime];
    [self.getMessageButton setTitle:title forState:UIControlStateDisabled];
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
