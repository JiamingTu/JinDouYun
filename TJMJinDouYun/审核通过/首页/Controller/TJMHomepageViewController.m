//
//  TJMHomepageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/18.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomepageViewController.h"
#import "TJMHomeOrderTableViewCell.h"
#import "TJMHomeHeaderView.h"
#import "TJMPickUpViewController.h"
#import "TJMQRCodeSingInViewController.h"
#import "TJMBaiduMapViewController.h"
#import "TJMHomepageViewController+Category.h"

static NSInteger homepageOrderSize = 5;

@interface TJMHomepageViewController ()<UITableViewDelegate,UITableViewDataSource,TJMHomeOrderTableViewCellDelegate>
{
    
    UIButton *_selectButton;
    TJMOrderModel *_selectModel;
    NSInteger _selectModelOrderStatus;
    NSIndexPath *_selectIndexPath;
    NSMutableArray *_selectDataArray;
    NSInteger _loadViewStatus;
    NSString *_cityName;
    BOOL _isNeed;
    BOOL _locationDidUpdate;
}



@property (nonatomic,assign) BOOL isWorking;

@property (weak, nonatomic) IBOutlet UIView *imaginaryLineView;

//数据源
@property (nonatomic,strong) NSMutableDictionary *dataSourceDictionary;

//我的位置
@property (nonatomic,strong) BMKUserLocation *myLoc;

//刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;

//热力图
@property (nonatomic,strong) TJMBaiduMapViewController *mapVC;

@end

@implementation TJMHomepageViewController
#pragma  mark - lazy loading
- (UIButton *)naviLeftButton {
    if (!_naviLeftButton) {
//        UIImage *image = [UIImage imageNamed:@"nav_btn_drop-down-"];
        UIFont *font = [UIFont systemFontOfSize:15];
        self.naviLeftButton = [[UIButton alloc]init];
//        self.naviLeftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.naviLeftButton.titleLabel.font = font;
        _cityName = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMCityName];
        if (_cityName) {
            NSString *city =  [_cityName substringWithRange:NSMakeRange(0, _cityName.length - 1)];
            [self.naviLeftButton setTitle:city forState:UIControlStateNormal];
        } else {
            [self.naviLeftButton setTitle:@"厦门" forState:UIControlStateNormal];
        }
        [self setNaviLeftButtonFrame];
        [self.naviLeftButton setTitleColor:TJMFUIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        [self.naviLeftButton setImage:image forState:UIControlStateNormal];
        [self.naviLeftButton addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.naviLeftButton.tag = 1100;
    }
    return _naviLeftButton;
}
- (void)setNaviLeftButtonFrame {
    UIFont *font = _naviLeftButton.titleLabel.font;
    _naviLeftButton.frame = CGRectMake(_naviLeftButton.frame.origin.x, _naviLeftButton.frame.origin.y, _naviLeftButton.titleLabel.text.length * font.pointSize + 4, font.pointSize + 2);
}

- (NSMutableDictionary *)dataSourceDictionary {
    if (!_dataSourceDictionary) {
        self.dataSourceDictionary = [NSMutableDictionary dictionary];
    }
    return _dataSourceDictionary;
}
- (MJRefreshNormalHeader *)header {
    if (!_header) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self deleteDataSourceDict];
            //重新获取位置后请求
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
            TJMLog(@"刷新了刷新了刷新了");
            //重置footer no more data
            [self.footer resetNoMoreData];
        }];
    }
    return _header;
}

- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //重新获取位置后请求
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
        }];
    }
    return _footer;
}
- (TJMBaiduMapViewController *)mapVC {
    if (!_mapVC) {
        self.mapVC = [[TJMBaiduMapViewController alloc]init];
    }
    return _mapVC;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"首页" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self configViews];
    //进入后台，进入程序 对应操作
    __weak TJMHomepageViewController *weakSelf = self;
    self.appDelegate.workTimeBlock = ^ {
        //清除原来数据
        [weakSelf deleteDataSourceDict];
        //获取工作状态
        [weakSelf getWorkingStatusWithIsNeedUpdateDataSource:NO];
        [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
        [TJMHUDHandle showRequestHUDAtView:weakSelf.view message:nil];
    };
    self.appDelegate.stopTimer = ^ {
        [weakSelf cancelTiemr];
    };
    //获取个人信息
    [self.appDelegate getFreeManInfoWithViewController:self fail:^(NSString *failMsg) {
        
    }];
    //接收位置更新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:kTJMLocationCityNameDidChange object:nil];
    //获取工作状态以改变页面
    [self getWorkingStatusWithIsNeedUpdateDataSource:YES];
    //获取位置后请求
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加监听 当日期改变时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChange:) name:NSCalendarDayChangedNotification object:nil];
    //KVO 当工作状态改变时 调用
    [self addObserver:self forKeyPath:@"isWorking" options:NSKeyValueObservingOptionNew context:nil];
    [self getWorkingStatusWithIsNeedUpdateDataSource:NO];
    //根据orderStatus 更新 页面
    [self updateListAccountSelectModel];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCalendarDayChangedNotification object:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCalendarDayChangedNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"isWorking"];
    //停止计时
    [self cancelTiemr];
    //记录 _selectModel 的 orderStatus
    if (_selectModel) {
        _selectModelOrderStatus = _selectModel.orderStatus.integerValue;
    }
    //如果正在刷新 需要停止刷新
    if (self.header.isRefreshing) {
        [self.header endRefreshing];
    }
    if (self.footer.isRefreshing) {
        [self.footer endRefreshing];
    }
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //
    CGFloat height = self.headerImageView.frame.size.height;
    self.headerImageView.layer.cornerRadius = height / 2;
    self.headerImageView.layer.masksToBounds = YES;
}
#pragma  mark dealloc
- (void)dealloc {
    //关闭定时器
    [self cancelTiemr];
    //关闭KVO
    [self.appDelegate removeFreeManInfoWithViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTJMLocationCityNameDidChange object:nil];
}

#pragma  mark - 页面设置
- (void)configViews {
    //设置tableView 刷新控件
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    //注册区头视图
    [self.tableView registerClass:[TJMHomeHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeHeader"];
    //设置做导航按钮（城市选择）
//    [self setNaviLeftButtonFrameWithButton:self.naviLeftButton];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.naviLeftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置右边导航按钮
    UIButton *rightButton = [self setRightNaviItemWithImageName:@"nav_btn_heatmap" orTitle:nil titleColorHexValue:0x000000 fontSize:0];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_btn_map"] forState:UIControlStateSelected];
    //增加虚线
    [self tjm_constructImaginaryLineWithView:self.imaginaryLineView];
    //设置抢单按钮为已选择按钮
    _selectButton = self.rabOrderButton;
    
}
- (void)reloadOrderList {
    if (_locationDidUpdate) {
        //页面将要显示时获取工作状态，更新页面
        [self.dataSourceDictionary removeAllObjects];
        //获取出工状态
        [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
        [TJMHUDHandle hiddenHUDForView:self.view];
        [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
        _locationDidUpdate = NO;
    } else {
        [TJMHUDHandle hiddenHUDForView:self.view];
    }
}

#pragma  mark - 按钮方法
#pragma  mark 导航按钮
- (void)leftItemAction:(UIButton *)button {
    TJMLog(@"%zd",button.tag);

}
- (void)rightItemAction:(UIButton *)button {
    //self.view addSubview
    //定时器不停止？
    button.selected = !button.selected;
    if (button.selected) {
        self.mapVC.cityName = self.naviLeftButton.titleLabel.text;
        [self.view addSubview:self.mapVC.view];
    } else {
        [self.mapVC.view removeFromSuperview];
        self.mapVC = nil;
    }
}
#pragma  mark 出工/收工按钮
- (IBAction)startOrStopWorkingAction:(UIButton *)sender {
    NSString *mainString = sender.selected ? @"收工" : @"出工";
    NSString *title = [NSString stringWithFormat:@"确定%@？",mainString];
    [self alertViewWithTag:10000 delegate:self title:title cancelItem:@"取消" sureItem:@"确定"];
}
#pragma  mark 抢单、待取货、待送货按钮
- (IBAction)selectStatusOrder:(UIButton *)sender {
    [TJMRequestH httpRequestManagerCancelRequest];
    if ([_selectButton isEqual:sender]) {
        return;
    }
    sender.selected = !sender.selected;
    _selectButton.selected = !_selectButton.selected;
    _selectButton = sender;
    [self.tableView reloadData];
    if (!self.isWorking) {
        //如果是收工状态 就设置
        [self setOrderListWithKnockOff];
        [self.header beginRefreshing];
    }
    self.selectLineViewLeft.constant = (sender.tag - 100) * TJMScreenWidth / 3;
    if (self.isWorking) {
        //如果是出工状态，才刷新列表
        //刷新
        //如果正在刷新的时候 点击 这三个按钮 不会触发刷新 所以需要进行下列判断
        if (self.header.state == MJRefreshStateRefreshing) {
            [self deleteDataSourceDict];
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
        } else {
            [self.header beginRefreshing];
        }
    }
}
- (void)deleteDataSourceDict {
    //清空当前状态（抢单，待取，待送）下 字典的值
    [self.dataSourceDictionary removeObjectForKey:[self dataKey]];
    [self.dataSourceDictionary removeObjectForKey:[self pageKey]];
}

#pragma  mark - TDAlertViewDelegate
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        //如果是出工alert
        if (itemIndex == 0) {
            NSString *type = [alertView.title containsString:@"出工"] ? @"Start" : @"Stop";
            //收工或出工请求
            [TJMRequestH putFreeManWorkingStatusWithType:type success:^(id successObj, NSString *msg) {
                //请求成功后
                //设置isWorking KVO 修改界面等
                self.isWorking = [type isEqualToString:@"Start"];
                if (!self.isWorking) {
//                    [self cancelTiemr];
                    [self configHeaderAndFooterWithWorkStatus:self.isWorking];
                } else {
                    //如果是出工的话 配置 刷新
                    if (self.myLoc && _cityName) {
                        [self configHeaderAndFooterWithWorkStatus:self.isWorking];
                    }
                }
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:msg];
            } fail:^(NSString *failString) {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:failString];
            }];
        }
    } else if(alertView.tag == 10001) {
        //确认抢单？
        if (itemIndex == 0) {
            NSMutableArray *arr = self.dataSourceDictionary[[self dataKey]];
            TJMOrderModel *model = [arr objectAtIndex:_selectIndexPath.row];
            [TJMRequestH robOrderWithOrderId:model.orderId success:^(id successObj, NSString *msg) {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:msg];
                //删除数据
                [arr removeObjectAtIndex:_selectIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            } fail:^(NSString *failString) {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:failString];
            }];
        }
    }
}

#pragma  mark - 请求处理
#pragma  mark 获取出工状态
- (void)getWorkingStatusWithIsNeedUpdateDataSource:(BOOL)isNeed {
    _isNeed = isNeed;
    //判断出工状态
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            TJMFreeManInfo *freeManInfo = (TJMFreeManInfo *)successObj;
            //赋值KVO
            self.isWorking = [freeManInfo.workStatus boolValue];
        } fail:^(NSString *failString) {
            [TJMHUDHandle hiddenHUDForView:self.view];
            [TJMHUDHandle tapHUDWithTarget:self atView:self.view withMessage:@"加载失败，点击重试"];
        }];
    }
}
- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    [TJMHUDHandle hiddenHUDForView:self.view];
    [self getWorkingStatusWithIsNeedUpdateDataSource:YES];
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeCityName target:CLLocationCoordinate2DMake(0, 0)];
}
#pragma  mark 获取出工时间/当前金额 更新UI
- (void)getWorkingTimeAndConfigWithWorkingStatus:(BOOL)workStatus {
#pragma  mark 根据出工状态修改界面 和 设置定时器及定位
    //设置相应界面
    self.workButton.selected = workStatus;
    //修改出工状态label
    self.statusLabel.text = workStatus ? @"出工中" : @"待出工";
    //鹰眼服务
    [self configbaiduTraceWithWorkStatus:workStatus];
    //上传FreeMan 位置
    [[TJMLocationService sharedLocationService] setUpLocationTrakerWithWorkStatus:workStatus timeInterval:30];
#pragma  mark 请求获得今日出工时间、今日收益
    [TJMRequestH getFreeManWorkingTimeWithType:TJMTodayData success:^(id successObj, NSString *msg) {
//        [TJMHUDHandle hiddenHUDForView:self.view];
        NSDictionary *data = successObj[@"data"];
        //设置今日收益label、今日工作时间label
        CGFloat income = [data[@"income"] doubleValue];
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",income];
        //获取当前出工时间
        self.totalTimeLabel.text = [self tjm_getTimeStringWithTimestamp:[data[@"workTime"] integerValue]];
        //判断工作状态
#pragma mark 必须在得到出工时间后 判断 开启定时器
#warning tiemr on-off must in different method
        if (workStatus) {
            //如果是出工，就异步开启定时器
            [self startTimerWithTimestamp:[data[@"workTime"] integerValue]];
        } else {
            [self cancelTiemr];
        }
    } fail:^(NSString *failString) {
        TJMLog(@"%@",failString);
    }];
    
}

#pragma  mark 根据出工状态设置刷新控件
- (void)configHeaderAndFooterWithWorkStatus:(BOOL)workStatus {
    if (workStatus) {
        //如果是出工状态
        [self.footer resetNoMoreData];
        [self.footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
        //重设header
        self.tableView.mj_header = self.header;
        [self setOrderList];
    } else {
        //收工
        [self setOrderListWithKnockOff];
        //停止定时器
        [self cancelTiemr];
        //隐藏hud
        [TJMHUDHandle hiddenHUDForView:self.view];
    }
}
#pragma  mark - 收工状态下的表 （抢单：空！其余可见）
- (void)setOrderListWithKnockOff {
    if (_selectButton.tag != 101) {
        //tableView 空白
        [self.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        //设置区头为没有更多数据
        [self.footer endRefreshingWithNoMoreData];
        //header设置为空
        self.tableView.mj_header = nil;
        //清空抢单数据
        NSMutableArray *deletKeys = [NSMutableArray array];
        for (int i = 0;  i < self.dataSourceDictionary.allKeys.count; i ++) {
            NSString *key = _dataSourceDictionary.allKeys[i];
            if ([key containsString:@"100"] || [key containsString:@"102"]) {
                //如果是抢单的 键
                [deletKeys addObject:key];
            }
        }
        [self.dataSourceDictionary removeObjectsForKeys:deletKeys];
        [self.tableView reloadData];
        
    } else {
        [self.footer resetNoMoreData];
        [self.footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
        //重设header
        self.tableView.mj_header = self.header;
        //开始刷新后 收工原因不会调用setOrderList 方法  需手动调用一次
        [self setOrderList];
    }
}


#pragma  mark - 设置订单列表
- (void)setOrderList {
    NSString *type;
    NSInteger status = 0;
    if (_selectButton.tag == 100) {
        type = TJMWaitRobOrder;
    } else if (_selectButton.tag == 101) {
        type = TJMStatusOrder;
        status = 2;
    } else if (_selectButton.tag == 102) {
        type = TJMStatusOrder;
        status = 3;
    }
    
    //如果没有页数 就存一个页数进去
    NSString *pageKey = [self pageKey];
    if (!self.dataSourceDictionary[pageKey]) {
        [self.dataSourceDictionary setObject:@0 forKey:pageKey];
    }
    NSInteger page = [self.dataSourceDictionary[pageKey] integerValue];
    TJMLog(@"现在是第%zd页",page);
    //请求
    TJMLog(@"请求了请求了请求了请求了请求了请求了++%@++%zd",type,status);
    [TJMRequestH getOrderListWithType:type myLocation:self.myLoc.location.coordinate page:page size:homepageOrderSize sort:nil dir:@"ASC" status:status cityName:_cityName success:^(id successObj, NSString *msg) {
        TJMOrderData *orderData = (TJMOrderData *)successObj;
        //如果 为空 则不能进行下列操作

        //如果数据是空 则停止刷新 并 noMoreData
        if (orderData.content.count == 0 || orderData.content == nil) {
            [self.header endRefreshing];
            [self.footer endRefreshingWithNoMoreData];
            [_tableView reloadData];
            [TJMHUDHandle hiddenHUDForView:self.view];
            return ;
        }
        //如果有数据
        NSMutableArray *array = [NSMutableArray arrayWithArray:orderData.content];
        //确定是下拉 还是 上拉
        if (page != 0) {
            //上拉加载
            NSMutableArray *dictArray = self.dataSourceDictionary[[self dataKey]];
            [dictArray addObjectsFromArray:array];
            [self.tableView reloadData];
            
            //判断 array.count 是否 小于 homepageOrderSize
            if (array.count < homepageOrderSize) {
                //如果小于 就没有更多数据了
                [self.footer endRefreshingWithNoMoreData];
            } else {
                //否则可以继续加载
                [self.footer endRefreshing];
            }
        } else {
            //刷新
            [self.dataSourceDictionary setObject:array forKey:[self dataKey]];
            [self.tableView reloadData];
            //停止刷新
            [self.tableView.mj_header endRefreshing];
        }
        //页数 ++
        [self.dataSourceDictionary  setObject:@(page + 1) forKey:pageKey];
        [TJMHUDHandle hiddenHUDForView:self.view];
    } fial:^(NSString *failString) {
        if (self.header.isRefreshing) {
            [self.header endRefreshing];
        }
        if (self.footer.isRefreshing) {
            [self.footer endRefreshing];
        }
        [TJMHUDHandle hiddenHUDForView:self.view];
    }];
}

- (NSString *)dataKey {
    return  [NSString stringWithFormat:@"%zd",_selectButton.tag];
}
- (NSString *)pageKey {
    return  [NSString stringWithFormat:@"%zdPage",_selectButton.tag];
}

#pragma  mark - 通知
- (void)dayChange:(NSNotification *)notification {
    //日期变更后 重新请求 出工状态
    [self getWorkingStatusWithIsNeedUpdateDataSource:YES];
}
- (void)cityDidChange:(NSNotification *)notification {
    TJMLog(@"位置已更新，开始刷新列表");
    _locationDidUpdate = YES;
    if ([notification.userInfo[@"myLocation"] isKindOfClass:[NSString class]]) {
        if (self.header.isRefreshing) {
            [self.header endRefreshing];
        }
        if (self.footer.isRefreshing) {
            [self.footer endRefreshing];
        }
        [self.appDelegate getLocationAuthorization];
        return;
    }
    if ([notification.userInfo[@"cityName"] isEqualToString:@"fail"]) {
        //反检索失败
        [self alertViewWithTag:10002 delegate:self title:@"定位失败，请刷新重试" cancelItem:nil sureItem:@"确定"];
        return;
    }
    _cityName = notification.userInfo[@"cityName"];
    NSString *city =  [_cityName substringWithRange:NSMakeRange(0, _cityName.length - 1)];
    [self.naviLeftButton setTitle:city forState:UIControlStateNormal];
//    [self setNaviLeftButtonFrameWithButton:_naviLeftButton];
    [self setNaviLeftButtonFrame];
    self.myLoc = notification.userInfo[@"myLocation"];
    if (self.myLoc && _cityName) {
        [self configHeaderAndFooterWithWorkStatus:self.isWorking];
    }
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *dataKey = [self dataKey];
    if ([self.dataSourceDictionary.allKeys containsObject:dataKey]) {
        NSArray *arr = self.dataSourceDictionary[dataKey];
        if (arr.count == 0) {
            //如果 没有数据
            [self.footer endRefreshingWithNoMoreData];
        }
        return arr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMHomeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    NSString *dataKey = [self dataKey];
    _selectDataArray = self.dataSourceDictionary[dataKey];
    TJMOrderModel *model = _selectDataArray[indexPath.row];

    [cell setValueWithModel:model];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TJMHomeHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeHeader"];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 * TJMHeightRatio;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 271 * TJMHeightRatio;
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMHomeOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TJMLog(@"%@",cell.currentModel.orderStatus);
    if (cell.currentModel.orderStatus.integerValue != 1) {
        _selectModel = cell.currentModel;
        [self performSegueWithIdentifier:@"HomeToOrderDetail" sender:cell.currentModel];
    }
}
#pragma  mark - TJMHomeOrderTableViewCellDelegate
#pragma  mark 抢单
- (void)robOrderWithButtonTag:(NSInteger)tag order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    if (tag == 10) {
        //抢单
        [self alertViewWithTag:10001 delegate:self title:@"确认抢单？" cancelItem:@"取消" sureItem:@"确定"];
        //获取indexPath 得到对应model
        _selectIndexPath = [self.tableView indexPathForCell:cell];
        
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSArray *arr = self.dataSourceDictionary[[self dataKey]];
        TJMOrderModel *model = arr[indexPath.row];
        //查看地图
        TJMLocation *consignerLoc = [[TJMLocation alloc]initWithCoordinate2D:CLLocationCoordinate2DMake(model.consignerLat.floatValue, model.consignerLng.floatValue) title:@"取货点"];
        TJMLocation *reciverLoc = [[TJMLocation alloc]initWithCoordinate2D:CLLocationCoordinate2DMake(model.receiverLat.floatValue, model.receiverLng.floatValue) title:@"送货点"];
        _selectModel = cell.currentModel;
        [self performSegueWithIdentifier:@"BaiduMap" sender:@[consignerLoc,reciverLoc]];
    }
}
#pragma  mark 确认取货按钮
- (void)waitPickUpWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    //确认取货
    if (self.isWorking == NO) {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"收工状态无法取货"];
    } else {
        _selectModel = model;
        [self performSegueWithIdentifier:@"SurePickUp" sender:model];
    }
    
}
#pragma  mark 到付
- (void)payOnDeliveryWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    _selectModel = model;
     [self performSegueWithIdentifier:@"HelpPay" sender:model];
}
#pragma  mark 验证码 签收
- (void)codeSignInWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    //先跳到二维码界面
    _selectModel = model;
    [self performSegueWithIdentifier:@"QRCodeSingIn" sender:model];

}
#pragma  mark 代收货款
- (void)helpToCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    _selectModel = model;
    [self performSegueWithIdentifier:@"HelpPay" sender:model];
}
#pragma  mark 代收货款拒收
- (void)refuseCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    _selectModel = model;
    [self performSegueWithIdentifier:@"HelpPay" sender:model];
}
#pragma  mark 导航（待取货、待送货）
- (void)naviToDestinationWithLatitude:(CGFloat)lat longtitude:(CGFloat)lng order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeNaviService target:CLLocationCoordinate2DMake(lat, lng)];
}

#pragma - 判断selectModel 状态 更新页面
//在页面将要消失时 记录 被选中的model 的 订单状态
//页面将要出现时 判断状态是否一致，从而刷新页面
- (void)updateListAccountSelectModel {
    if ([_selectDataArray containsObject:_selectModel] ) {
        if (_selectModelOrderStatus == 2) {
            //是从 待取货 界面 push的
            if (_selectModel.orderStatus.integerValue != _selectModelOrderStatus) {
                [self deleteOrder];
            }
        } else if (_selectModelOrderStatus == 3) {
            if (_selectModel.orderStatus.integerValue != _selectModelOrderStatus) {
                if (_selectModel.orderStatus.integerValue == 7) {
                    NSInteger index = [_selectDataArray indexOfObject:_selectModel];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self deleteOrder];
                }
            }
        }
    }
}
//删除对应model
- (void)deleteOrder {
    NSInteger index = [_selectDataArray indexOfObject:_selectModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_selectDataArray removeObject:_selectModel];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isWorking"]) {
        BOOL isWorking = [change[@"new"] boolValue];
        //得到工作状态后开始相关操作
        [self getWorkingTimeAndConfigWithWorkingStatus:isWorking];
        //如果这时候，以下两个数据都有了 且 需要进行刷新 则刷新
        if (self.myLoc && _cityName) {
            if (_isNeed) {
                [self configHeaderAndFooterWithWorkStatus:isWorking];
            }
        }
    } else if ([keyPath isEqualToString:kKVOFreeManInfo]) {
        TJMFreeManInfo *freeManInfo = change[@"new"];
        if (![freeManInfo isEqual:[NSNull null]] && freeManInfo != nil) {
            if (freeManInfo.photo != nil) {
                NSString *path = [NSString stringWithFormat:@"%@%@",TJMPhotoBasicAddress,freeManInfo.photo];
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    image = [image getCropImage];
                    image = nil;
                    self.headerImageView.image = image ? image : [UIImage imageNamed:@"img_user"];
                }];
            }
            self.nameLabel.text = freeManInfo.realName;
        }
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"QRCodeSingIn"] || [segue.identifier isEqualToString:@"HelpPay"]) {
        [segue.destinationViewController setValue:sender forKey:@"orderModel"];
    } else if ([segue.identifier isEqualToString:@"SurePickUp"]) {
        TJMPickUpViewController *pickUpVC = segue.destinationViewController;
        pickUpVC.orderModel = sender;
    } else if ([segue.identifier isEqualToString:@"BaiduMap"]) {
        [segue.destinationViewController setValue:sender forKey:@"locations"];
    } else if ([segue.identifier isEqualToString:@"HomeToOrderDetail"]) {
        [segue.destinationViewController setValue:sender forKey:@"orderModel"];
        [segue.destinationViewController setValue:[NSString stringWithFormat:@"%zd",_isWorking] forKey:@"isWorking"];
    }
}




@end
