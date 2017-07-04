//
//  TJMSettingViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMSettingViewController.h"
#import "TJMSettingTableViewCell.h"
@interface TJMSettingViewController ()<UITableViewDelegate,UITableViewDataSource,TDAlertViewDelegate,BTKTraceDelegate>

@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@end

@implementation TJMSettingViewController
#pragma  mark - lazy loading
- (NSArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = @[@"个人信息",@"修改密码",@"问题反馈",@"退出登录"];
    }
    return _titleArray;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"设置" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 *TJMHeightRatio;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMSettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"PersonInfo" sender:nil];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"Feedback" sender:nil];
    } else {
        
        [self alertViewWithTag:10000 delegate:self title:@"确定退出登录？" cancelItem:@"取消" sureItem:@"确定"];
        
        
        
    }
}
#pragma  mark - TDAlertView
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        [self getWorkStatus];
//        [self exitLogin];
    }
}

- (void)getWorkStatus {
#pragma  mark 获取开工状态
    //判断开工状态
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"退出登录..."];
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            TJMFreeManInfo *freeManInfo = (TJMFreeManInfo *)successObj;
            //赋值KVO
            BOOL workStatus = [freeManInfo.workStatus boolValue];
            if (workStatus) {
                //如果开工状态，收工后再退出
                [self stopWorking];
            } else {
                //如果收工状态，直接退出
                [self exitLogin];
                [_progressHUD hideAnimated:YES];
            }
        } fail:^(NSString *failString) {
            
        }];
    }
}

- (void)stopWorking {
    //收工请求
    [TJMRequestH putFreeManWorkingStatusWithType:@"Stop" success:^(id successObj, NSString *msg) {
        //收工成功后，退出登录
        [self exitLogin];
        //停止上传定位
        [[TJMLocationService sharedLocationService] setUpLocationTrakerWithWorkStatus:NO timeInterval:30];
        [self configbaiduTraceWithWorkStatus:NO];
        [TJMHUDHandle hiddenHUDForView:self.view];
    } fail:^(NSString *failString) {
        TJMLog(@"%@",failString);
        _progressHUD.label.text = [NSString stringWithFormat:@"%@,无法退出登录",failString];
        [_progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}

- (void)exitLogin {
    //请求成功后，退出登录
    [self deleteCarrierInfo];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *naviC = [storyboard instantiateViewControllerWithIdentifier:@"TJMUncheckedNaviController"];
    [self.appDelegate restoreRootViewController:naviC];
}
#pragma  mark 开启、关闭 鹰眼
- (void)configbaiduTraceWithWorkStatus:(BOOL)workStatus {
    BOOL result = [self.appDelegate initTraceService];
    if (workStatus && result) {
        TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
        // 设置开启轨迹服务时的服务选项，指定本次服务以“entityA”的名义开启
        BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:tokenModel.userId.description];
        // 开启服务
        [[BTKAction sharedInstance] startService:op delegate:self];
    } else {
        [[BTKAction sharedInstance] stopService:self];
    }
}
- (void)onStopService:(BTKServiceErrorCode)error {
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
        [[BTKAction sharedInstance] stopGather:self];
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
