//
//  TJMBindingBankCardViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/22.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBindingBankCardViewController.h"
#import "TJMUserInfoModel.h"
#import "TJMInfoTableViewCell.h"
#import "TJMTransferOutViewController.h"
#import "TJMMyBankCardViewController.h"
@interface TJMBindingBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,TJMInfoTableViewCellDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TJMUserInfos *infos;
@property (nonatomic,strong) NSMutableDictionary *parameters;
//银行信息
@property (nonatomic,strong) TJMBankData *bankData;

@end

@implementation TJMBindingBankCardViewController
#pragma  mark - lazy loading
- (TJMUserInfos *)infos {
    if (!_infos) {
        self.infos = [[TJMUserInfos alloc]initWithInfoType:TJMUserInfoTyptBindingBankCard];
    }
    return _infos;
}
- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViews];
}
#pragma  mark - 设置页面
- (void)configViews {
    //没有cell的地方去掉线条
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self setBackNaviItem];
    [self setRightNaviItemWithImageName:nil orTitle:@"提交" titleColorHexValue:0x333333 fontSize:15];
    
}

#pragma  mark - 按钮方法
#pragma  mark 右导航按钮 提交绑定
- (void)rightItemAction:(UIButton *)button {
    [self.view endEditing:NO];//去除对话框第一响应
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"请稍后..."];
    [TJMRequestH bindingBankCardWithParameters:self.parameters success:^(id successObj, NSString *msg) {
        progressHUD.label.text = msg;
        [progressHUD hideAnimated:YES afterDelay:1];
        TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
        //绑定成功后，获取银行卡列表 并转到相应界面
        [TJMRequestH getBankListOrBoundBankCarkListWithType:TJMGetBoundBankCardList(tokenModel.userId.description) success:^(id successObj, NSString *msg) {
            //得到 银行卡列表
            TJMBankCardData *bankCardData = (TJMBankCardData *)successObj;
            //转成可变数组
            NSMutableArray *bankCardArray = [NSMutableArray arrayWithArray:bankCardData.data];
            //获取上一个VC
            UIViewController *VC = [self popTargetViewControllerWithViewControllerNumber:2];
            //判断上一个VC的类型
            if ([VC isKindOfClass:[TJMTransferOutViewController class]]) {
                //如果是从提现跳转的 更改button的值 然后pop
                TJMTransferOutViewController *transgerOutVC = (TJMTransferOutViewController *)VC;
                //设置银行卡按钮title
                TJMBankCardModel *model = bankCardArray[0];
                //得到卡号后四位信息
                NSString *lastFour = [model.bankcard.description substringFromIndex:model.bankcard.description.length - 4];
                //拼接 银行名 + (卡号后四位)
                transgerOutVC.buttonTitle = [model.bank.bankName stringByAppendingFormat:@"（%@）",lastFour];
                transgerOutVC.bankCardArray = bankCardArray;
                transgerOutVC.selectBankCardModel = bankCardArray[0];
                [self.navigationController popToViewController:VC animated:YES];
            } else {
                //如果是从我的银行卡跳转来的 push到我的银行卡界面
                
                NSDictionary *dictionary = @{@"isFromBindingCard":@(YES),@"bankCardArray":bankCardArray};
                [self performSegueWithIdentifier:@"BindingToMyBankCard" sender:dictionary];

            }
        } fail:^(NSString *failString) {
            
        }];
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:1];
    }];
}
#pragma  mark - 手势
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:NO];
}
#pragma  mark - #pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;
    }//否则手势存在
    return YES;
}
#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infos.infos count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardInfoCell" forIndexPath:indexPath];
    TJMUserInfoModel *model = self.infos.infos[indexPath.row];
    cell.delegate = self;
    [cell setViewInfoWith:model];
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * TJMHeightRatio;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:NO];
    TJMInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (!cell.infoTextField.enabled) {
        if (!self.bankData) {
            [TJMRequestH getBankListOrBoundBankCarkListWithType:TJMGetBankList success:^(id successObj, NSString *msg) {
                self.bankData = (TJMBankData *)successObj;
                [self showPickerViewWithTableView:tableView successObj:self.bankData indexPaht:indexPath parameters:self.parameters];
            } fail:^(NSString *failString) {
                
            }];
        } else {
            //如果有bankData
            [self showPickerViewWithTableView:tableView successObj:self.bankData indexPaht:indexPath parameters:self.parameters];
        }
    }
    
    
}

#pragma  mark - TJMInfoTableViewCellDelegate
- (void)getInfoValue:(NSString *)value cell:(TJMInfoTableViewCell *)cell {
    if (cell.inputType) {
        if ([value containsString:@" "]) {
             NSArray *array = [value componentsSeparatedByString:@" "];
            value = @"";
            for (NSString *str in array) {
                value = [value stringByAppendingString:str];
            }
        }
        [self.parameters setObject:value forKey:cell.inputType];
        TJMLog(@"%@",self.parameters);
    }
}
#pragma  mrak - memory warning
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
    if ([segue.identifier isEqualToString:@"BindingToMyBankCard"]) {
        TJMMyBankCardViewController *myBankCardVC = segue.destinationViewController;
        myBankCardVC.isFromBindingCard = [sender[@"isFromBindingCard"] boolValue];
        myBankCardVC.dataSourceArray = sender[@"bankCardArray"];
    }
}


@end
