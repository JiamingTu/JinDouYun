//
//  TJMLoginViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMLoginViewController.h"

@interface TJMLoginViewController ()<CAAnimationDelegate>
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIView *loginSelectView;
//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetButtonConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageContrain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonContrain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnTopContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getMsgBtnBottomContrain;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswdTFLineContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumTFLineContrain;


@end

@implementation TJMLoginViewController

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        self.appDelegate = TJMAppDelegate;
    }
    return _appDelegate;
}

#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TJMLog(@"路径：%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    [self resetConstrains];
    [self configSubviews];

    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置标题
    [self setTitle:@"登录" fontSize:17 colorHexValue:0x333333];
    //设置导航颜色
    [self.navigationController.navigationBar tjm_setBackgroundColor:TJMFUIColorFromRGB(0xffdf22)];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
}

#pragma  mark - 界面配置
- (void)resetConstrains {
    [self resetVerticalConstrains:self.forgetButtonConstrain,self.registerButtonContrain,self.getMsgBtnTopContrain,self.getMsgBtnBottomContrain,self.pswdTFLineContrain,self.phoneNumTFLineContrain,self.textFieldContrain,self.loginButtonContrain, nil];
    [self resetHorizontalConstrains:self.bgImageContrain, nil];
}
- (void)configSubviews {
    
    
    //设置字体
    [UIFont adjustFont:14 forView:self.messageLoginButton,self.secretLoginButton,self.passwordTF,self.phoneNumberTF,self.getMessageButton, nil];
    [UIFont adjustFont:15 forView:self.forgetSecretButton,self.registerButton, nil];
    [UIFont adjustFont:18 forView:self.loginButton, nil];
    //
}






#pragma  mark - 界面按钮方法
#pragma  mark 登录
- (IBAction)loginAction:(UIButton *)sender {
    //判断是否电话号码
    if ([self.phoneNumberTF.text isMobileNumber]) {
        //判断密码是否为空
        if (self.passwordTF.text != nil) {
            NSDictionary *form = @{@"mobile":self.phoneNumberTF.text,@"pwd":self.passwordTF.text};
            [TJMRequestH accountCheckWithForm:form checkType:TJMLogin success:^(id successObj,NSString *msg) {
                //获取并存入token
                NSDictionary *dict = successObj[@"data"];
                TJMTokenModel *tokenModel = [[TJMTokenModel alloc]initWithDictionary:dict];
                [TJMSandBoxManager saveTokenToPath:tokenModel];
                [self.appDelegate setAlias];
            } fail:^(NSString *failString) {
                
            }];
        }
    }else {
        TJMLog(@"请输入正确的电话号码");
    }
}
- (IBAction)forgetPasswordAction:(UIButton *)sender {
}




#pragma  mark - UITextFieldDelegate
#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [textField.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    
    //密码输入框
    if ([textField isEqual:self.passwordTF]) {
        //如果是中文或空格 则不允许输入
        if ([string isChinese]) {
            return NO;
        } else if ([newValue containsString:@" "]) {
            return NO;
        }
    }
    //电话号码输入框
    if ([textField isEqual:self.phoneNumberTF]) {
        //判断是否11位 不到验证码按钮不可用
        return [newValue length] > 11 ? NO : YES;
    }
    if (_phoneNumberTF.text.length == 11) {
        //如果密码输入框没内容 按钮不可用
        self.loginButton.enabled = newValue.length > 5 ? YES : NO;
    }
    return YES;
}


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
