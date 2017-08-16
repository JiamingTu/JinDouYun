//
//  TJMCodeSignInViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/10.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMCodeSignInViewController.h"
@interface TJMCodeSignInViewController ()<UITextFieldDelegate>
{
    NSInteger time;
}
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMessageButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMessageButtonHeightConstraint;

//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterButtonWidthConstraint;

//视图
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *getMessageLabel;

@property (weak, nonatomic) IBOutlet UIButton *keyOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *KeyTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyFourBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *keySixBtn;
@property (weak, nonatomic) IBOutlet UIButton *keySevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyEightBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyNineBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyZeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *keySureBtn;

@property (nonatomic,strong) NSMutableString *codeString;
//倒计时
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic,strong) NSThread *countDownThread;
//
@property (weak, nonatomic) IBOutlet UIButton *getMsgButton;


@end

@implementation TJMCodeSignInViewController
#pragma  mark - lazy loading
- (NSMutableString *)codeString {
    if (!_codeString) {
        self.codeString = [NSMutableString string];
    }
    return _codeString;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"客户签收" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self configViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UIView animateWithDuration:0.35 animations:^{
        self.navBarBgAlpha = @"0.0";
//    }];
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.logoImageTopConstraint,self.logoImageHeightConstraint,self.logoImageBottomConstraint,self.keyButtonHeightConstraint,self.keyboardTopConstraint,self.getMessageButtonBottomConstraint,self.getMessageButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.textFieldLeftConstraint,self.enterButtonWidthConstraint, nil];
}
- (void)configViews {
    self.codeTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    //设置返回按钮
    [self setBackNaviItem];
    
}

- (void)adjustFonts {
    [self tjm_adjustFont:14 forView:self.codeTextField,self.getMessageLabel, nil];
    [self tjm_adjustFont:18 forView:self.keyOneBtn,self.KeyTwoBtn,self.keyThreeBtn,self.keyFourBtn,self.keyFiveBtn,self.keySixBtn,self.keySevenBtn,self.keyEightBtn,self.keyNineBtn,self.keyZeroBtn,self.keySureBtn, nil];
}

#pragma  mark - 按钮方法
#pragma  mark 键盘按钮
- (IBAction)customKeyboardAction:(UIButton *)sender {
    if (sender.tag < 200) {
        [self.codeString appendFormat:@"%zd",sender.tag - 100];
        self.codeTextField.text = self.codeString;
    } else if (sender.tag == 200){
        //commit
        
    } else {
        [self.codeString deleteCharactersInRange:NSMakeRange(self.codeString.length - 1, 1)];
        self.codeTextField.text = self.codeString;
    }
}
#pragma  mark 获取验证码按钮
- (IBAction)geiSignInMsgCode:(UIButton *)sender {
    [TJMHUDHandle showRequestHUDAtView:self.view message:@"请稍后..."];
    [TJMRequestH getSignInCodeOrSignWithType:TJMMsgCodeSignIn parameters:@{@"orderNo":self.orderModel.orderNo} success:^(id successObj, NSString *msg) {
        //获取成功，隐藏HUD
        [TJMHUDHandle hiddenHUDForView:self.view];
        //开始倒计时
        self.getMessageLabel.text = @"59秒";
        [self startTimer];
        //button不可用
        sender.enabled = NO;
        
    } fail:^(NSString *failString) {
        
    }];
}
#pragma  mark - 提交按钮
- (IBAction)commitAction:(UIButton *)sender {    
    if (self.codeTextField.text.length == 6) {
        //位数正确
        NSDictionary *parameters = @{@"code":self.codeTextField.text,@"orderNo":self.orderModel.orderNo};
        [TJMRequestH getSignInCodeOrSignWithType:TJMSignInOrder parameters:parameters success:^(id successObj, NSString *msg) {
            //签收成功
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _orderModel.orderStatus = @4;
                UIViewController *VC = [self popTargetViewControllerWithViewControllerNumber:2];
                VC.navBarBgAlpha = @"1.0";
                [self.navigationController popToViewController:VC animated:YES];
            });
        } fail:^(NSString *failString) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:failString];
        }];
    }
}

- (void)startTimer {
    if (!self.countDownTimer) {
        time = 59;
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.countDownThread = [NSThread currentThread];
                [strongSelf.countDownThread setName:@"timerThread"];
                strongSelf.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:strongSelf selector:@selector(countDown) userInfo: nil repeats:YES];
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:strongSelf.countDownTimer forMode:NSDefaultRunLoopMode];
                [runloop run];
            }
        });
    }
    
}
- (void)countDown {
    time -= 1;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.getMessageLabel.text = [NSString stringWithFormat:@"%zd秒",time];
        if (time == 0) {
            self.getMessageLabel.text = @"获取验证码";
            [self cancelTiemr];
            self.getMsgButton.enabled = YES;
        }
    }];
}

#pragma  mark 销毁定时器
- (void)cancel{
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}
//需在开启的线程中销毁
- (void)cancelTiemr {
    if (self.countDownTimer && self.countDownThread) {
        [self performSelector:@selector(cancel) onThread:self.countDownThread withObject:nil waitUntilDone:NO];
    }
}

#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [textField.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    [self.codeString appendString:string];
    //判断是否6位的数字 大于6位则不可再输入
    if ([newValue length] > 6 || ![newValue isNumber]) {
        return NO;
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
