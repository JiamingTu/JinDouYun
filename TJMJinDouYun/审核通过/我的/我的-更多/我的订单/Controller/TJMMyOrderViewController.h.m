//
//  TJMDetailOfMineViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyOrderViewController.h"
#import "TJMHomeOrderTableViewCell.h"
const NSInteger _myOrderSize = 5;
@interface TJMMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,TJMHomeOrderTableViewCellDelegate,TDAlertViewDelegate>
{
    NSInteger _myOrderPage;
}
@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;

@property (nonatomic,strong) BMKUserLocation *myLoc;

@property (nonatomic,assign) BOOL isWorking;
@end

@implementation TJMMyOrderViewController
#pragma  mark lazy loading
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
        _myOrderPage = 0;
    }
    return _dataSourceArray;
}
- (MJRefreshNormalHeader *)header {
    if (!_header) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //清空当前状态（抢单，待取，待送）下 字典的值
            [self.dataSourceArray removeAllObjects];
            _myOrderPage = 0;
            //重新请求
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
            //重置footer no more data
            [self.footer resetNoMoreData];
        }];
    }
    return _header;
}
- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _myOrderPage ++;
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
        }];
    }
    return _footer;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的订单" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
    [self configViews];
    
    [self getWorkingStatus];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLocationDidChage:) name:kTJMLocationDidChange object:nil];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTJMLocationDidChange object:nil];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
}
#pragma  mark - 页面设置
- (void)configViews {
    
}
- (void)reloadDataTableView {
    [self.tableView reloadData];
}

#pragma  mark 获取开工状态
- (void)getWorkingStatus {
    //判断开工状态
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            TJMFreeManInfo *freeManInfo = (TJMFreeManInfo *)successObj;
            //赋值KVO
            self.isWorking = [freeManInfo.workStatus boolValue];
            [self.header beginRefreshing];
            [TJMHUDHandle hiddenHUDForView:self.view];
        } fail:^(NSString *failString) {
            [TJMHUDHandle hiddenHUDForView:self.view];
        }];
    }
}

#pragma  mark - 订单列表
- (void)setOrderList {
    //请求
    NSString *cityName = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMCityName];
    [TJMRequestH getOrderListWithType:TJMFreeManAllOrder myLocation:self.myLoc.location.coordinate page:_myOrderPage size:_myOrderSize sort:nil dir:@"ASC" status:0 cityName:cityName success:^(id successObj, NSString *msg) {
        TJMMyOrderData *myOrderData = (TJMMyOrderData *)successObj;
        //如果没有更多数据 就 结束刷新
        if (myOrderData.data == nil || myOrderData.data.count == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:myOrderData.data];
        
        if (_myOrderPage == 0) {
            //刷新
            //停止刷新
            [self.tableView.mj_header endRefreshing];
            
        } else {
            //上拉加载
            //停止刷新
            [self.tableView.mj_footer endRefreshing];
        }
        if (array.count < _myOrderSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataSourceArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } fial:^(NSString *failString) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMHomeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    TJMOrderModel *model = self.dataSourceArray[indexPath.row];
    //计算距离

    [cell setValueWithModel:model];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 271 * TJMHeightRatio;
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"MyOrderToOrderDetail" sender:self.dataSourceArray[indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * TJMHeightRatio;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma  mark - 通知
- (void)myLocationDidChage:(NSNotification *)notification {
    if ([notification.userInfo[@"myLocation"] isKindOfClass:[NSString class]]) {
        //定位失败
        [self alertViewWithTag:10000 delegate:self title:@"定位失败，请重试" cancelItem:nil sureItem:@"确定"];
        if (self.header.isRefreshing) {
            [self.header endRefreshing];
        }
        if (self.footer.isRefreshing) {
            [self.footer endRefreshing];
        }
        return;
    }
    self.myLoc = notification.userInfo[@"myLocation"];
    if (self.myLoc) {
        
        [self setOrderList];
    }
}

#pragma  mark - TDAlertViewDelegate
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    
}

#pragma  mark - TJMHomeOrderTableViewCellDelegate

#pragma  mark 确认取货按钮
- (void)waitPickUpWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    if (!self.isWorking) {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"收工状态无法取货"];
        return;
    }
    //确认取货
    [self performSegueWithIdentifier:@"MyOrderToPickUp" sender:model];
}
#pragma  mark 到付
- (void)payOnDeliveryWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [self performSegueWithIdentifier:@"MyOrderToDeliveryPay" sender:model];
}
#pragma  mark 验证码 签收
- (void)codeSignInWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    //先跳到二维码界面
    [self performSegueWithIdentifier:@"MyOrderToSignIn" sender:model];
    
}
#pragma  mark 代收货款
- (void)helpToCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [self performSegueWithIdentifier:@"MyOrderToDeliveryPay" sender:model];
}
#pragma  mark 代收货款拒收
- (void)refuseCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [self performSegueWithIdentifier:@"MyOrderToDeliveryPay" sender:model];
}
#pragma  mark 导航（待取货、待送货）
- (void)naviToDestinationWithLatitude:(CGFloat)lat longtitude:(CGFloat)lng order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeNaviService target:CLLocationCoordinate2DMake(lat, lng)];
}
#pragma  mark 查看详情
- (void)checkDetailsWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [self performSegueWithIdentifier:@"MyOrderToOrderDetail" sender:model];
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
    if ([segue.identifier isEqualToString:@"MyOrderToOrderDetail"] || [segue.identifier isEqualToString:@"MyOrderToPickUp"] || [segue.identifier isEqualToString:@"MyOrderToDeliveryPay"] || [segue.identifier isEqualToString:@"MyOrderToSignIn"]) {
        [segue.destinationViewController setValue:sender forKey:@"orderModel"];
    }
    if ([segue.identifier isEqualToString:@"MyOrderToOrderDetail"]) {
        [segue.destinationViewController setValue:[NSString stringWithFormat:@"%zd",self.isWorking] forKey:@"isWorking"];
    }
}


@end
