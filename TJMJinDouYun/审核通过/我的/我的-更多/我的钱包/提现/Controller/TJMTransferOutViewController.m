//
//  TJMTransferOutViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTransferOutViewController.h"
#import "TJMMyBankCardViewController.h"
#import "TJMTransferOutSuccessViewController.h"
@interface TJMTransferOutViewController ()<UITextFieldDelegate>
{
    BOOL _bankCardStatus;
}
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bandCardViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *symbolLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashButtonHeightConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardLabelRightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankCardButton;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashAllButton;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;





@end

@implementation TJMTransferOutViewController



#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"提现" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
    [self addObserver:self forKeyPath:@"buttonTitle" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"buttonTitle"];
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.mainViewTopConstraint,self.bandCardViewHeightConstraint,self.cashLabelTopConstraint,self.cashLabelBottomConstraint,self.symbolLabelHeightConstraint,self.lineViewTopConstraint,self.lineViewBottomConstraint,self.cashButtonTopConstraint,self.cashButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.bankCardLabelRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.bankCardLabel,self.bankCardButton,self.cashLabel, nil];
    [self tjm_adjustFont:13 forView:self.noticeLabel,self.cashAllButton, nil];
    [self tjm_adjustFont:20 forView:self.symbolLabel, nil];
    [self tjm_adjustFont:40 forView:self.moneyTextField, nil];
    [self tjm_adjustFont:18 forView:self.cashButton, nil];
}
- (void)configViews {
    [self.bankCardButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    _bankCardStatus = [self.buttonTitle containsString:@"绑定"] ? NO : YES;
    self.noticeLabel.text = [NSString stringWithFormat:@"可提金额%@元，",self.blanceNum];
    if (self.bankCardArray.count != 0) {
        self.selectBankCardModel = self.bankCardArray[0];
    }
    [self setBackNaviItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noticeLabel.text = [NSString stringWithFormat:@"可提金额%@元，",self.blanceNum];
}
#pragma  mark - 页面按钮
- (IBAction)bankCardAction:(id)sender {
    NSString *segueId = _bankCardStatus ? @"TransferOutToBankCard" : @"TransferOutToBindingBancCard";
    [self performSegueWithIdentifier:segueId sender:self.bankCardArray];
    
}
- (IBAction)cashAllAction:(UIButton *)sender {
    self.moneyTextField.text = self.blanceNum;
}
- (IBAction)transferOutAction:(UIButton *)sender {
    if (_bankCardStatus) {
        //如果是绑定状态，判断输入框
        CGFloat money = [self.moneyTextField.text doubleValue];
        if ([self.moneyTextField.text floatValue] > [self.blanceNum floatValue]) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"超出可提现金额"];
        }else if (money < 0.01) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"至少提现0.01元"];
        }else {
            //提现操作
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.selectBankCardModel.carrierCardId,@"bankCardId",self.moneyTextField.text,@"money", nil];
            MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view  message:@"请稍后..."];
            [TJMRequestH deleteBankCardOrTransferOutWithType:TJMTransferOut parameters:parameters success:^(id successObj, NSString *msg) {
                [TJMHUDHandle hiddenHUDForView:self.view];
                //跳转至成功页面
                [self performSegueWithIdentifier:@"CashResult" sender:@{@"money":self.moneyTextField.text,@"bankCardModel":self.selectBankCardModel}];
                //更改可提现金额
                CGFloat canCashMoney = [self.blanceNum doubleValue];
                self.blanceNum = [NSString stringWithFormat:@"%.2f",canCashMoney - money];
            } fail:^(NSString *failString) {
                progressHUD.label.text = failString;
                [progressHUD hideAnimated:YES afterDelay:1.5];
            }];
        }
    }
}
#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"buttonTitle"]) {
        [self.bankCardButton setTitle:change[@"new"] forState:UIControlStateNormal];
        _bankCardStatus = [self.buttonTitle containsString:@"绑定"] ? NO : YES;
    }
}
#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text             = textField.text;
    NSString *decimalSeperator = @".";
    NSCharacterSet *charSet    = nil;
    NSString *numberChars      = @"0123456789";
    
    if ([string isEqualToString:decimalSeperator] && [text length] == 0) {
        return NO;
    }
    
    NSRange decimalRange = [text rangeOfString:decimalSeperator];
    BOOL isDecimalNumber = (decimalRange.location != NSNotFound);
    if (isDecimalNumber) {
        charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
        if ([string rangeOfString:decimalSeperator].location != NSNotFound) {
            return NO;
        }
    }
    else {
        numberChars = [numberChars stringByAppendingString:decimalSeperator];
        charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
    }
    
    NSCharacterSet *invertedCharSet = [charSet invertedSet];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:invertedCharSet];
    text = [text stringByReplacingCharactersInRange:range withString:trimmedString];
    
    if (isDecimalNumber) {
        NSArray *arr = [text componentsSeparatedByString:decimalSeperator];
        if ([arr count] == 2) {
            if ([arr[1] length] > 2) {
                return NO;
            }
        }
    }
    textField.text = text;
    return NO;
}

#pragma  mark - memory warning
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
    if ([segue.identifier isEqualToString:@"TransferOutToBankCard"]) {
        TJMMyBankCardViewController *myBankCardVC = segue.destinationViewController;
        myBankCardVC.dataSourceArray = self.bankCardArray;
    } else if ([segue.identifier isEqualToString:@"CashResult"]) {
        TJMTransferOutSuccessViewController *cashSuccessVC = segue.destinationViewController;
        cashSuccessVC.bankCardModel = sender[@"bankCardModel"];
        cashSuccessVC.money = sender[@"money"];

    }
}



@end
