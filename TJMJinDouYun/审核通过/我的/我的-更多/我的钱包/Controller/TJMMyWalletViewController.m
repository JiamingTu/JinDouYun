//
//  TJMMyWalletViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyWalletViewController.h"
#import "TJMTransferOutViewController.h"
#import "TJMMyBankCardViewController.h"
@interface TJMMyWalletViewController ()
//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightConstraint;

//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceNumLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceNumLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageHeightConstraint;



//水平

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageRightConstraint;



@end

@implementation TJMMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的钱包" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self configViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    //获取金额
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            TJMFreeManInfo *infoModel = successObj;
            self.balanceNumLabel.text = [NSString stringWithFormat:@"%.2f",[infoModel.money floatValue]];
            [TJMHUDHandle hiddenHUDForView:self.view];
        } fail:^(NSString *failString) {
            [TJMHUDHandle hiddenHUDForView:self.view];
            //提示问题
            
        }];
    }
    
    self.navBarBgAlpha = @"1.0";
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollViewContentHeightConstraint.constant = TJMScreenHeight - 64 + 0.5;
}
#pragma  mark - 设置页面
- (void)configViews {
    [self setBackNaviItem];
    [self setRightNaviItemWithImageName:nil orTitle:@"交易记录" titleColorHexValue:0x333333 fontSize:15];
}
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.imageTopConstraint,self.imageHeightConstraint,self.imageBottomConstraint,self.balanceLabelHeightConstraint,self.balanceLabelBottomConstraint,self.balanceNumLabelHeightConstraint,self.balanceNumLabelBottomConstraint,self.titleImageHeightConstraint , nil];
    [self tjm_resetHorizontalConstraints:self.titleImageRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.balanceLabel,self.withdrawalLabel,self.myBankCardLabel, nil];
    [self tjm_adjustFont:25 forView:self.balanceNumLabel, nil];
}
#pragma  mark - 按钮绑定
- (void)rightItemAction:(UIButton *)button {
    //点击交易记录后执行的方法
    [self performSegueWithIdentifier:@"TradingRecord" sender:nil];

}
#pragma  mark 提现&我的银行卡 按钮
- (IBAction)transferOutAndMyBankCardAction:(UIButton *)sender {
    //判断是否绑定银行卡
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    [TJMRequestH getBankListOrBoundBankCarkListWithType:TJMGetBoundBankCardList(tokenModel.userId.description) success:^(id successObj, NSString *msg) {
        TJMBankCardData *bankCardData = successObj;
        NSMutableArray *bankCardArray = [NSMutableArray arrayWithArray:bankCardData.data];
        
        NSString *segueId;
        //判断 是点击 提现 还是 我的银行卡
        if (sender.tag == 100) {
            //如果是点击提现按钮
            NSString *buttonTitle;
            segueId = @"TransferOut";
            //判断是否有绑定银行卡
            if (bankCardData.data.count == 0) {
                //如果没有 则银行卡按钮显示 “绑定银行卡”
                buttonTitle = @"绑定银行卡";
            } else {
                //如果有绑定 银行卡按钮显示 “xx银行（卡号后四位）”
                //获取第一张银行卡信息
                TJMBankCardModel *model = bankCardArray[0];
                //得到卡号后四位信息
                NSString *lastFour = [model.bankcard.description substringFromIndex:model.bankcard.description.length - 4];
                //拼接 银行名 + (卡号后四位)
                buttonTitle = [model.bank.bankName stringByAppendingFormat:@"（%@）",lastFour];
            }
            [self performSegueWithIdentifier:segueId sender:@{@"blanceNum":_balanceNumLabel.text,@"buttonTitle":buttonTitle,@"bankCardArray":bankCardArray}];
        } else {
            if (bankCardArray.count == 0) {
                segueId = @"WalletToBindingBancCard";
            } else {
                segueId = @"WalletToBankCard";
            }
            [self performSegueWithIdentifier:segueId sender:bankCardArray];
        }
    } fail:^(NSString *failString) {
        
    }];
    
    
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
    if ([segue.identifier isEqualToString:@"TransferOut"]) {
        TJMTransferOutViewController *transferOutVC = segue.destinationViewController;
        transferOutVC.blanceNum = sender[@"blanceNum"];
        transferOutVC.buttonTitle = sender[@"buttonTitle"];
        transferOutVC.bankCardArray = sender[@"bankCardArray"];
    } else if ([segue.identifier isEqualToString:@"WalletToBankCard"]) {
        TJMMyBankCardViewController *myBankCardVC = segue.destinationViewController;
        myBankCardVC.dataSourceArray = sender;
    }
}


@end
