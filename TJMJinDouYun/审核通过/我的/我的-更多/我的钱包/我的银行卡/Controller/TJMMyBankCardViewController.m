//
//  TJMMyBankCardViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/22.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyBankCardViewController.h"
#import "TJMMyBankCardTableViewCell.h"
#import "TJMTransferOutViewController.h"
@interface TJMMyBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isDelete;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation TJMMyBankCardViewController
#pragma  mark - lazy loading

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的银行卡" fontSize:17 colorHexValue:0x333333];
    [self configViews];
}
#pragma  mark - 设置页面
- (void)configViews {
    [self setBackNaviItem];
}
//重写左导航方法
- (void)itemAction:(UIButton *)button {
    TJMLog(@"酱紫嘛");
    if (self.isFromBindingCard) {
        //点击“我的银行卡”->”绑定“完银行卡后 进入此页 执行 需要退pop 两个页面
        UIViewController *VC = [self popTargetViewControllerWithViewControllerNumber:2];
        [self.navigationController popToViewController:VC animated:YES];

    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSourceArray objectAtIndex:section]) {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMyBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardCell" forIndexPath:indexPath];
    TJMBankCardModel *bankCardModel = self.dataSourceArray[indexPath.section];
    [cell setViewValueWithModel:bankCardModel];
    
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TJMBankCardModel *bankCardModel = self.dataSourceArray[indexPath.section];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:bankCardModel.carrierCardId,@"bankCardId", nil];
        //删除数据
        MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"正在删除"];
        //服务器禁用银行卡
        [TJMRequestH deleteBankCardOrTransferOutWithType:TJMDeleteBankCard parameters:parameters success:^(id successObj, NSString *msg) {
            progressHUD.label.text = msg;
            [progressHUD hideAnimated:YES afterDelay:1.5];
            //删除dataSourceArray
            [self.dataSourceArray removeObject:bankCardModel];
            if (_dataSourceArray.count == 0) {
                //pop
                [self afterDeletePopViewController];
            }
            //删除cell
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } fail:^(NSString *failString) {
            progressHUD.label.text = failString;
            [progressHUD hideAnimated:YES afterDelay:1.5];
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJMMyBankCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSInteger number;
    if (self.isFromBindingCard) number = 2;
    else number = 1;
    UIViewController *VC = [self popTargetViewControllerWithViewControllerNumber:number];
    if ([VC isKindOfClass:[TJMTransferOutViewController class]]) {
        TJMTransferOutViewController *transferOutVC = (TJMTransferOutViewController *)VC;
        transferOutVC.bankCardArray = self.dataSourceArray;
        transferOutVC.selectBankCardModel = self.dataSourceArray[indexPath.section];
    }
    [self.navigationController popToViewController:VC animated:YES];
    
    
    
}

#pragma  mark - 删除银行卡后跳转
- (void)afterDeletePopViewController {
    NSInteger number;
    if (self.isFromBindingCard) number = 2;
    else number = 1;
    UIViewController *viewController = [self popTargetViewControllerWithViewControllerNumber:number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToViewController:viewController animated:YES];
    });
    if ([viewController isKindOfClass:[TJMTransferOutViewController class]]) {
        TJMTransferOutViewController *transferOutVC = (TJMTransferOutViewController *)viewController;
        transferOutVC.buttonTitle = @"绑定银行卡";
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
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
