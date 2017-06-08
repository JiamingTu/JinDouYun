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
@interface TJMHomepageViewController ()<UITableViewDelegate,UITableViewDataSource,TJMHomeOrderTableViewCellDelegate,BTKTraceDelegate>
{
    NSInteger _currentTimestamp;
    UIButton *_selectButton;
    TJMOrderModel *_selectModel;
    NSIndexPath *_selectIndexPath;
    NSInteger _loadViewStatus;
}
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imaginaryLineViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonCutLineHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleCutLineHeightConstraint;
//抢单等按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalMoneyLabelHeightConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageRightConstraint;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineViewLeft;

//开工时间定时器
@property (nonatomic, strong) NSThread *timerThread;
@property (nonatomic,strong) NSTimer *workingTimeTimer;
@property (nonatomic,assign) BOOL isWorking;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
//菊花
@property (nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation TJMHomepageViewController
#pragma  mark - lazy loading
- (UIButton *)naviLeftButton {
    if (!_naviLeftButton) {
        UIImage *image = [UIImage imageNamed:@"nav_btn_drop-down-"];
        UIFont *font = [UIFont systemFontOfSize:15];
        self.naviLeftButton = [[UIButton alloc]init];
        self.naviLeftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.naviLeftButton.titleLabel.font = font;
        NSString *city = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMCityName];
        if (city) {
            [self.naviLeftButton setTitle:city forState:UIControlStateNormal];
        } else {
            [self.naviLeftButton setTitle:@"厦门" forState:UIControlStateNormal];
        }
        [self.naviLeftButton setTitleColor:TJMFUIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.naviLeftButton setImage:image forState:UIControlStateNormal];
        [self.naviLeftButton addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.naviLeftButton.tag = 1100;
    }
    return _naviLeftButton;
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
            //清空当前状态（抢单，待取，待送）下 字典的值
            [self.dataSourceDictionary removeObjectForKey:@(_selectButton.tag)];
            [self.dataSourceDictionary removeObjectForKey:[NSString stringWithFormat:@"%zdnumber",_selectButton.tag]];
            [self.dataSourceDictionary removeObjectForKey:[NSString stringWithFormat:@"%zdtotal",_selectButton.tag]];
            //重新获取位置后请求
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
            //重新获取位置后请求
            [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
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
    [self setFonts];
    [self resetConstraints];
    [self configViews];
    //进入后台，进入程序 对应操作
    __weak TJMHomepageViewController *weakSelf = self;
    self.appDelegate.workTimeBlock = ^ {
        [weakSelf getWorkingStatus];
    };
    self.appDelegate.stopTimer = ^ {
        [weakSelf cancelTiemr];
    };
    //获取个人信息
    [self.appDelegate getPersonInfoWithViewController:self];
    //获取位置后请求
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocAndCityName target:CLLocationCoordinate2DMake(0, 0)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加监听 当日期改变时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChange:) name:NSCalendarDayChangedNotification object:nil];
    //KVO 当工作状态改变时 调用
    [self addObserver:self forKeyPath:@"isWorking" options:NSKeyValueObservingOptionNew context:nil];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:kTJMLocationCityNameDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kTJMLocationDidChange object:nil];
    //页面将要显示时获取工作状态，更新页面
    [self getWorkingStatus];
    //开启定位服务
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCalendarDayChangedNotification object:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCalendarDayChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTJMLocationCityNameDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTJMLocationDidChange object:nil];
    [self removeObserver:self forKeyPath:@"isWorking"];
    //停止计时
    [self cancelTiemr];
}
- (void)viewDidLayoutSubviews {
    //
    CGFloat height = self.headerImageView.frame.size.height;
    self.headerImageView.layer.cornerRadius = height / 2;
    self.headerImageView.layer.masksToBounds = YES;
}
#pragma  mark dealloc
- (void)dealloc {
    //关闭定时器
    [self cancelTiemr];
    //关闭通知
    [self.appDelegate removePersonInfoWithViewController:self];
}

#pragma  mark - 页面配置
- (void)configViews {
    //设置tableView 刷新控件
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    //注册区头视图
    [self.tableView registerClass:[TJMHomeHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeHeader"];
    //设置做导航按钮（城市选择）
    [self setNaviLeftButtonFrameWithButton:self.naviLeftButton];
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
//约束
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.headerImageTopConstraint,self.headerImageHeightConstraint,self.workButtonTopConstraint,self.workButtonHeightConstraint,self.earningsImageTopConstraint,self.earningsImageHeightConstraint,self.earningsImageBottomConstraint,self.workTimeImageHeightConstraint,self.imaginaryLineViewTopConstraint,self.buttonCutLineHeightConstraint,self.middleCutLineHeightConstraint,self.buttonHeightConstraint,self.totalMoneyLabelHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.nameLabelLeftConstraint,self.workTimeImageRightConstraint,self.earningsImageRightConstraint, nil];
}
//设置字体
- (void)setFonts {
    [self tjm_adjustFont:16 forView:self.nameLabel, nil];
    [self tjm_adjustFont:13 forView:self.currentStatusLabel,self.statusLabel, nil];
    [self tjm_adjustFont:18 forView:self.workButton, nil];
    [self tjm_adjustFont:12 forView:self.todayEarningsLabel,self.workTimeLabel, nil];
    [self tjm_adjustFont:15 forView:self.totalTimeLabel,self.totalMoneyLabel,self.rabOrderButton,self.waitFetchButton,self.waitSendButton, nil];
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
#pragma  mark 开工/收工按钮
- (IBAction)startOrStopWorkingAction:(UIButton *)sender {
    NSString *mainString = sender.selected ? @"收工" : @"开工";
    NSString *title = [NSString stringWithFormat:@"确定%@？",mainString];
    [self alertViewWithTag:10000 delegate:self title:title cancelItem:@"取消" sureItem:@"确定"];
}
#pragma  mark 抢单、待取货、待送货按钮
- (IBAction)selectStatusOrder:(UIButton *)sender {
    if ([_selectButton isEqual:sender]) {
        return;
    }
    sender.selected = !sender.selected;
    _selectButton.selected = !_selectButton.selected;
    _selectButton = sender;
    self.selectLineViewLeft.constant = (sender.tag - 100) * TJMScreenWidth / 3;
    [self.tableView reloadData];
    if (self.isWorking) {
        //如果是开工状态，才刷新列表
        //刷新
        [self.header beginRefreshing];
    }
    
}

#pragma  mark - TDAlertViewDelegate
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        //如果是开工alert
        if (itemIndex == 0) {
            NSString *type = [alertView.title containsString:@"开工"] ? @"Start" : @"Stop";
            //出工或开工请求
            [TJMRequestH putFreeManWorkingStatusWithType:type success:^(id successObj, NSString *msg) {
                //请求成功后
                //设置isWorking KVO 修改界面等
                self.isWorking = [type isEqualToString:@"Start"];
                if (!self.isWorking) {
                    [self cancelTiemr];
                }
            } fail:^(NSString *failString) {
                
            }];
        }
    } else {
        //确认抢单？
        if (itemIndex == 0) {
            NSMutableArray *arr = self.dataSourceDictionary[@(_selectButton.tag)];
            _selectModel = [arr objectAtIndex:_selectIndexPath.row];
            [TJMRequestH robOrderWithOrderId:_selectModel.orderId success:^(id successObj, NSString *msg) {
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
#pragma  mark 获取开工状态
- (void)getWorkingStatus {
    self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    //判断开工状态
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(tokenModel.userId.description) form:nil success:^(id successObj, NSString *msg) {
            TJMFreeManInfo *freeManInfo = (TJMFreeManInfo *)successObj;
            //赋值KVO
            self.isWorking = [freeManInfo.workStatus boolValue];
        } fail:^(NSString *failString) {
            
        }];
    }
}
#pragma  mark 获取开工时间/当前金额 更新UI
- (void)getWorkingTimeAndConfigWithWorkingStatus:(BOOL)workStatus {
#pragma  mark 根据开工状态修改界面 和 设置定时器及定位
    //设置相应界面
    self.workButton.selected = workStatus;
    //修改出工状态label
    self.statusLabel.text = workStatus ? @"出工中" : @"待出工";

    //设置刷新视图
    [self configHeaderAndFooterWithWorkStatus:workStatus];
    //鹰眼服务
    [self configbaiduTraceWithWorkStatus:workStatus];
#pragma  mark 请求获得今日出工时间、今日收益
    [TJMRequestH getFreeManWorkingTimeWithType:TJMTodayData success:^(id successObj, NSString *msg) {
        [TJMHUDHandle hiddenHUDForView:self.view];
        NSDictionary *data = successObj[@"data"];
        //设置今日收益label、今日工作时间label
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%@",data[@"income"]];
        //获取当前开工时间
        self.totalTimeLabel.text = [self tjm_getTimeStringWithTimestamp:[data[@"workTime"] integerValue]];
        //判断工作状态
#pragma mark 必须在得到开工时间后 判断 开启定时器
#warning tiemr on-off must in different method
        if (workStatus) {
            //如果是开工，就异步开启定时器
            [self startTimerWithTimestamp:[data[@"workTime"] integerValue]];
        }
    } fail:^(NSString *failString) {
        self.progressHUD.label.text = failString;
        [self.progressHUD hideAnimated:YES afterDelay:1.5];
        TJMLog(@"%@",failString);
    }];
    
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
- (void)onStartService:(BTKServiceErrorCode)error {
    if (error == BTK_START_SERVICE_SUCCESS) {
        [[BTKAction sharedInstance] startGather:self];
    }
}
- (void)onStopService:(BTKServiceErrorCode)error {
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
         [[BTKAction sharedInstance] stopGather:self];
    }
}
- (void)onStartGather:(BTKGatherErrorCode)error {
    
}
- (void)onStopGather:(BTKGatherErrorCode)error {
    
}
#pragma  mark 根据开工状态设置刷新控件
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
        //tableView 空白
        [self.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        //设置区头为没有更多数据
        [self.footer endRefreshingWithNoMoreData];
        //header设置为空
        self.tableView.mj_header = nil;
        //清空所有数据
        [self.dataSourceDictionary removeAllObjects];
        [self.tableView reloadData];
        //停止定时器
        [self cancelTiemr];
    }
}

#pragma  mark - 设置订单列表
- (void)setOrderList {
    if (!self.isWorking) return;//如果不是开工状态 就return
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
    NSInteger number,totalPage,page;//设置页数
    if ([self.dataSourceDictionary.allKeys containsObject:[NSString stringWithFormat:@"%zdtotal",_selectButton.tag]]) {
        //如果存在 tag&total 这个key 就说明已经请求过 则根据页数 继续请求（下一页）
        number = [self.dataSourceDictionary[[NSString stringWithFormat:@"%zdnumber",_selectButton.tag]] integerValue];
        totalPage = [self.dataSourceDictionary[[NSString stringWithFormat:@"%zdtotal",_selectButton.tag]] integerValue];
        if (number + 1 >= totalPage) {
            //如果number + 1 >= totalPage 则已经是最后一页
            //no more data
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        } else {
            page = number + 1;
        }
    } else {
        //如果不存在，则从零开始
        page = 0;
    }
    //请求
    [TJMRequestH getOrderListWithType:type page:page size:5 sort:nil dir:@"ASC" status:status success:^(id successObj, NSString *msg) {
        TJMOrderData *orderData = (TJMOrderData *)successObj;
        //如果 为空 则不能进行下列操作
        if (orderData.totalPages == nil) return;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:orderData.content];
        if ([self.dataSourceDictionary.allKeys containsObject:[NSString stringWithFormat:@"%zdtotal",_selectButton.tag]]) {
            //上拉加载
            NSMutableArray *dictArray = self.dataSourceDictionary[@(_selectButton.tag)];
            [dictArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.dataSourceDictionary  setObject:orderData.number forKey:[NSString stringWithFormat:@"%zdnumber",_selectButton.tag]];
            [self.tableView.mj_footer endRefreshing];
        } else {
            //刷新
            [self.dataSourceDictionary setObject:array forKey:@(_selectButton.tag)];
            [self.dataSourceDictionary  setObject:orderData.number forKey:[NSString stringWithFormat:@"%zdnumber",_selectButton.tag]];
            [self.dataSourceDictionary setObject:orderData.totalPages forKey:[NSString stringWithFormat:@"%zdtotal",_selectButton.tag]];
            [self.tableView reloadData];
            //停止刷新
            [self.tableView.mj_header endRefreshing];
        }
    } fial:^(NSString *failString) {
        
    }];
}

#pragma  mark - 通知
- (void)dayChange:(NSNotification *)notification {
    //日期变更后 重新请求 开工状态
    [self getWorkingStatus];
}
- (void)cityDidChange:(NSNotification *)notification {
    NSString *city = notification.userInfo[@"cityName"];
    city =  [city substringWithRange:NSMakeRange(0, city.length - 1)];
    [self.naviLeftButton setTitle:city forState:UIControlStateNormal];
    [self setNaviLeftButtonFrameWithButton:_naviLeftButton]; 
}
- (void)locationDidChange:(NSNotification *)notification {
    //位置信息
    BMKUserLocation *location = notification.userInfo[@"myLocation"];
    self.myLoc = location;
    if (self.myLoc) {
        [self getWorkingTimeAndConfigWithWorkingStatus:self.isWorking];
    }
}

#pragma  mark - timer
#pragma  mark 开启定时器
- (void)startTimerWithTimestamp:(NSInteger)timestamp {
    //如果从服务器获取的时间改了 赋值还是要赋的
    _currentTimestamp = timestamp;
    //如果timer还存在（没有停止），那就不重新创建子线程 和 timer 了
    if (!self.workingTimeTimer) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.timerThread = [NSThread currentThread];
                [strongSelf.timerThread setName:@"timerThread"];
                strongSelf.workingTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:strongSelf selector:@selector(timerAction:) userInfo: nil repeats:YES];
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:strongSelf.workingTimeTimer forMode:NSDefaultRunLoopMode];
                [runloop run];
            }
        });
    }
}
#pragma  mark 定时器绑定方法
- (void)timerAction:(NSTimer *)timer {
    //继续在分线程中计算 时间
    _currentTimestamp += 1;
    NSString *timeString = [self tjm_getTimeStringWithTimestamp:_currentTimestamp];
    //返回主线程
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.totalTimeLabel.text = timeString;
    }];
}
#pragma  mark 销毁定时器
- (void)cancel{
    if (self.workingTimeTimer) {
        [self.workingTimeTimer invalidate];
        self.workingTimeTimer = nil;
    }
}
//需在开启的线程中销毁
- (void)cancelTiemr {
    if (self.workingTimeTimer && self.timerThread) {
        [self performSelector:@selector(cancel) onThread:self.timerThread withObject:nil waitUntilDone:YES];
    }
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSourceDictionary.allKeys containsObject:@(_selectButton.tag)]) {
        NSArray *arr = self.dataSourceDictionary[@(_selectButton.tag)];
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
    cell.delegate = self;
    NSArray *arr = self.dataSourceDictionary[@(_selectButton.tag)];
    TJMOrderModel *model = arr[indexPath.row];
    //计算距离
    
    CLLocationCoordinate2D getLoc = CLLocationCoordinate2DMake(model.consignerLat.floatValue, model.consignerLng.floatValue);
    CLLocationDistance distance = [[TJMLocationService sharedLocationService] calculateDistanceFromMyLocation:self.myLoc.location.coordinate toGetLocation:getLoc];
    model.getDistance = distance;
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
    [cell setSelected:NO animated:YES];
    TJMLog(@"%@",cell.currentModel.orderStatus);
    if (cell.currentModel.orderStatus.integerValue != 1) {

        [self performSegueWithIdentifier:@"HomeToOrderDetial" sender:cell.currentModel];
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
        NSArray *arr = self.dataSourceDictionary[@(_selectButton.tag)];
        TJMOrderModel *model = arr[indexPath.row];
        //查看地图
        TJMLocation *consignerLoc = [[TJMLocation alloc]initWithCoordinate2D:CLLocationCoordinate2DMake(model.consignerLat.floatValue, model.consignerLng.floatValue) title:@"取货点"];
        TJMLocation *reciverLoc = [[TJMLocation alloc]initWithCoordinate2D:CLLocationCoordinate2DMake(model.receiverLat.floatValue, model.receiverLng.floatValue) title:@"送货点"];
        [self performSegueWithIdentifier:@"BaiduMap" sender:@[consignerLoc,reciverLoc]];
        
        
    }
}
#pragma  mark 确认取货按钮
- (void)waitPickUpWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    //确认取货
    [self performSegueWithIdentifier:@"SurePickUp" sender:model];
}
#pragma  mark 到付
- (void)payOnDeliveryWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    
    
    
    
    
}
#pragma  mark 验证码 签收
- (void)codeSignInWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    //先跳到二维码界面
    [self performSegueWithIdentifier:@"QRCodeSingIn" sender:model];

}
#pragma  mark 导航（待取货、待送货）
- (void)naviToDestinationWithLatitude:(CGFloat)lat longtitude:(CGFloat)lng order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell {
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeNaviService target:CLLocationCoordinate2DMake(lat, lng)];
}



#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isWorking"]) {
        BOOL isWorking = [change[@"new"] boolValue];
        if (self.myLoc) {
            [self getWorkingTimeAndConfigWithWorkingStatus:isWorking];
        }
    } else if ([keyPath isEqualToString:kKVOPersonInfo]) {
        TJMPersonInfoModel *personInfo = change[@"new"];
        if (![personInfo isEqual:[NSNull null]]) {
            NSString *path = [TJMPhotoBasicAddress stringByAppendingString:personInfo.photo];
            [self.headerImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"img_user"]];
            self.nameLabel.text = personInfo.tel;
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
    if ([segue.identifier isEqualToString:@"QRCodeSingIn"]) {
        TJMQRCodeSingInViewController *QRCodeSingInVC = segue.destinationViewController;
        QRCodeSingInVC.orderModel = sender;
    } else if ([segue.identifier isEqualToString:@"SurePickUp"]) {
        TJMPickUpViewController *pickUpVC = segue.destinationViewController;
        pickUpVC.orderModel = sender;
    } else if ([segue.identifier isEqualToString:@"BaiduMap"]) {
        [segue.destinationViewController setValue:sender forKey:@"locations"];
    } else if ([segue.identifier isEqualToString:@"HomeToOrderDetial"]) {
        [segue.destinationViewController setValue:sender forKey:@"orderModel"];
    }
}




@end
