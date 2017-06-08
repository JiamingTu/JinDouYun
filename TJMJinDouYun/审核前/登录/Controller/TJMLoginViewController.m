//
//  TJMLoginViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMLoginViewController.h"
#import "TJMTabBarViewController.h"
@interface TJMLoginViewController ()<CAAnimationDelegate,UITextFieldDelegate,YYKeyboardObserver>
{
    UIButton *_selectButton;
    CGFloat _offsetHeight;
    CGFloat _countDownTime;
    CGFloat _keyboardHeight;
}



//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetButtonConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBottomContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeightConstraint;



//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswdTFLineConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumTFLineConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineConstraint;
//初始不更改
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMessageButtonTrailingConstraint;

//属性
@property (weak, nonatomic) IBOutlet UIView *loginSelectView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *selectLineView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImageView;


@property (nonatomic,strong) NSTimer *countDownTimer;



@end

@implementation TJMLoginViewController


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
    //设置标题
    [self setTitle:@"登录" fontSize:17 colorHexValue:0x333333];
    //设置字体大小
    [self adjustFonts];
    [self resetConstraints];
    [self configSubviews];
    TJMLog(@"路径：%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    _selectButton = self.messageLoginButton;
    //键盘监听
    [TJMYYKeyboardManager addObserver:self];
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置导航颜色
    self.navBarBgAlpha = @"0.0";
    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _offsetHeight = self.view.frame.size.height - CGRectGetMaxY(self.mainView.frame);
    //设置阴影
    [self setShadowWithView:self.shadowView shadowColor:TJMFUIColorFromRGB(0xffdf22)];
}
- (void)dealloc {
    //移除监听
    [TJMYYKeyboardManager removeObserver:self];
    //清空定时器
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}
#pragma  mark - 界面配置
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.forgetButtonConstrain,self.registerButtonConstraint,self.getMsgBtnTopConstraint,self.getMsgBtnBottomConstraint,self.pswdTFLineConstraint,self.phoneNumTFLineConstraint,self.textFieldConstraint,self.loginButtonConstraint,self.userImageTopConstraint,self.logoTopConstraint,self.logoHeightConstraint,self.logoBottomContraint,self.loginButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.bgImageConstraint, nil];
}
- (void)configSubviews {
    
}

- (void)adjustFonts {
    //设置字体
    [self tjm_adjustFont:14 forView:self.messageLoginButton,self.secretLoginButton,self.passwordTF,self.phoneNumberTF,self.getMessageButton, nil];
    [self tjm_adjustFont:15 forView:self.forgetSecretButton,self.registerButton, nil];
    [self tjm_adjustFont:18 forView:self.loginButton, nil];
    //
}

#pragma  mark - 界面按钮方法
#pragma  mark 登录
- (IBAction)loginAction:(UIButton *)sender {

    //判断是否电话号码
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //判断密码/验证码 是否为空
        if (self.passwordTF.text != nil) {
            //开始转菊花
            MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"正在登录"];
            switch ([_selectButton isEqual:self.messageLoginButton]) {
                //如果是验证码登录
                case 1: {
                    //短信验证码登录 调用接口
                    NSDictionary *form = @{@"mobile":self.phoneNumberTF.text,@"code":self.passwordTF.text};
                    [TJMRequestH accountCheckWithForm:form checkType:TJMCodeLogin success:^(id successObj, NSString *msg) {
                        
                        [self loginSuccessWithObject:successObj progressHUD:progressHUD];
                        
                    } fail:^(NSString *failString) {
                        [self loginFailWithProgressHUD:progressHUD failString:failString];
                    }];
                }
                    break;
                //如果是密码登录
                case 0: {
                    NSDictionary *form = @{@"mobile":self.phoneNumberTF.text,@"pwd":[self.passwordTF.text MD5]};
                    [TJMRequestH accountCheckWithForm:form checkType:TJMLogin success:^(id successObj,NSString *msg) {
                        [self loginSuccessWithObject:successObj progressHUD:progressHUD];
                    } fail:^(NSString *failString) {
                        [self loginFailWithProgressHUD:progressHUD failString:failString];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }else {
        TJMLog(@"请输入正确的电话号码");
        //提示框HUD
    }
}
//登录成功调用
- (void)loginSuccessWithObject:(id)object progressHUD:(MBProgressHUD *)progressHUD {
    //收起键盘
    [self.view endEditing:NO];
    NSDictionary *dict = object[@"data"];
    TJMTokenModel *tokenModel = [[TJMTokenModel alloc]initWithDictionary:dict];
    //存token
    [TJMSandBoxManager saveTokenToPath:tokenModel];
    //设置别名
    [self.appDelegate setAlias];
    
    //跳转页面
    //判断是否审核通过
    [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
        TJMFreeManInfo *freeManInfo = (TJMFreeManInfo *)successObj;
        //登录成功
        //输入框清空
        self.phoneNumberTF.text = nil;
        self.passwordTF.text = nil;
        //hud显示
        progressHUD.label.text = @"登录成功";
        [progressHUD hideAnimated:YES afterDelay:1.5];
        //判断考试 和资料审核
        if ([freeManInfo.materialStatus isEqualToNumber:@(2)] && [freeManInfo.examStatus isEqualToNumber:@(4)]) {
            //审核通过，直接跳入首页
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TJMTabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TJMTabBarController"];
            [self.appDelegate restoreRootViewController:tabBarVC];
        } else {
            //其他状态 进入 “成为自由人界面”
            TJMLog(@"meterialStatus : %@ ---- examStatus : %@",freeManInfo.materialStatus,freeManInfo.examStatus);
            [self performSegueWithIdentifier:@"LoginToChecking" sender:freeManInfo];
        }
        

    } fail:^(NSString *failString) {
        [self loginFailWithProgressHUD:progressHUD failString:failString];
    }];

}
- (void)loginFailWithProgressHUD:(MBProgressHUD *)progressHUD failString:(NSString *)string {
    progressHUD.label.text = string;
    [progressHUD hideAnimated:YES afterDelay:1.5];
}


- (IBAction)changeLoginWayAction:(UIButton *)sender {
    //改变按钮文字颜色
    sender.selected = !sender.selected;
    _selectButton.selected = !_selectButton.selected;
    _selectButton = sender;
    //改变细线 位置
    CGFloat constant = [sender isEqual:self.messageLoginButton] ? 0 : self.selectLineView.frame.size.width;
    self.selectLineConstraint.constant = constant;
    //验证码按钮是否隐藏
    self.getMessageButton.hidden = [_selectButton isEqual:self.messageLoginButton] ? NO : YES;
    self.getMessageButtonTrailingConstraint.constant = [_selectButton isEqual:self.messageLoginButton] ? 0 : self.getMessageButton.frame.size.width + 5;
    //密码框的placeholder
    self.passwordTF.placeholder = self.getMessageButton.hidden ? @"请输入密码" : @"请输入验证码";
    //键盘类型
    self.passwordTF.keyboardType = self.getMessageButton.hidden ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    //是否密码输入
    self.passwordTF.secureTextEntry = self.getMessageButton.hidden ? YES : NO;
    //密码框对应图标
    self.pwdImageView.image = [UIImage imageNamed:self.getMessageButton.hidden ? @"login_icon_password" : @"login_icon_Vc"];
}
//获取短信验证码按钮
- (IBAction)getMessageAction:(UIButton *)sender {
    //判断是否是手机号
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //获取验证码按钮进入倒计时
        [self countDownTimer];
        [sender setTitle:@"59秒" forState:UIControlStateNormal];
        sender.enabled = NO;
        //请求验证码
        [TJMRequestH shrotMessageCheckRequestWithPhoneNumber:_phoneNumberTF.text getCodeType:TJMGetLoginCode success:^(id successObj,NSString *msg) {
            TJMLog(@"%@",msg);
        } fail:^(NSString *failString) {
            
        }];
    } else {
        TJMLog(@"请输入正确的手机号");
    }
    
    
}
#pragma  mark - 定时器
- (void)countDownAction {
    _countDownTime--;
    NSString *title = [NSString stringWithFormat:@"%.0f秒",_countDownTime];
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
#pragma  mark - 键盘监听
- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    
    CGRect stratRect = transition.fromFrame;
    CGRect endRect = transition.toFrame;
    
    NSLog(@"%@------%@",NSStringFromCGRect(stratRect),NSStringFromCGRect(endRect));
//
//    NSLog(@"%d-----%d",transition.fromVisible,transition.toVisible);
    
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
#pragma  mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [textField.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    
    //密码输入框
    if ([textField isEqual:self.passwordTF]) {
        switch ([_selectButton isEqual:self.messageLoginButton]) {
            case 1: {
                //判断是否6位的数字 大于6位则不可再输入
                if ([newValue length] > 6 || ![newValue isNumber]) {
                    return NO;
                }
            }
                break;
            case 0: {
                //如果是中文或空格 则不允许输入
                if ([string isChinese]) {
                    return NO;
                } else if ([newValue containsString:@" "]) {
                    return NO;
                }
            }
            default:
                break;
        }
        if (_phoneNumberTF.text.length == 11) {
            //如果密码输入框没内容 按钮不可用
            self.loginButton.enabled = newValue.length > 5 ? YES : NO;
        }
    }
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
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Register"]) {
        [segue.destinationViewController setValue:@"注册" forKey:@"naviTitle"];
    } else if ([segue.identifier isEqualToString:@"ForgetPassword"]) {
        [segue.destinationViewController setValue:@"忘记密码" forKey:@"naviTitle"];
    } else if ([segue.identifier isEqualToString:@"LoginToChecking"]) {
        if (sender) {
            [segue.destinationViewController setValue:sender forKey:@"freeManInfo"];
        }
    }
    
    
}

@end
