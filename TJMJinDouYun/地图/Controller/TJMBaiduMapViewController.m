//
//  TJMBaiduMapViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBaiduMapViewController.h"
#import "AppDelegate.h"
@interface TJMBaiduMapViewController ()<BMKLocationServiceDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>
{
    BMKLocationService *_locService;
}

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) AppDelegate *appDelegate;
@end

@implementation TJMBaiduMapViewController
- (BMKMapView *)mapView {
    if (!_mapView) {
        self.mapView = [[BMKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//跟随模式
        _mapView.zoomLevel = 15;
    }
    return _mapView;
}

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    [self.view addSubview:self.mapView];
    
    self.appDelegate.InitNaviServices();
    [self startNavi];
    
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

#pragma  mark - 导航
#pragma  mark 进行路径规划
#warning 方法需完善终点
//发起导航
- (void)startNavi
{
    //回调后路算开始
    __weak BMKLocationService *weakLocService = _locService;
    __weak TJMBaiduMapViewController *weakSelf = self;
    self.appDelegate.GetResult = ^() {
        //节点数组
        NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
        
        //起点
        BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
        startNode.pos = [[BNPosition alloc] init];
        //获取当前位置
        startNode.pos.x = weakLocService.userLocation.location.coordinate.longitude;
        startNode.pos.y = weakLocService.userLocation.location.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_BaiduMapSDK;
        [nodesArray addObject:startNode];
        
        //终点
        BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
        endNode.pos = [[BNPosition alloc] init];
        endNode.pos.x = 114.077075;
        endNode.pos.y = 22.543634;
        endNode.pos.eType = BNCoordinate_BaiduMapSDK;
        [nodesArray addObject:endNode];
        //发起路径规划
        [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:weakSelf userInfo:nil];
    };
    
}
#pragma mark 算路成功回调,开启导航
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

- (void)searchDidFinished:(NSDictionary*)userInfo {
    NSLog(@"算路失败");
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
