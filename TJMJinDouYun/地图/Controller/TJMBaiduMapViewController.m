//
//  TJMBaiduMapViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBaiduMapViewController.h"
#import "AppDelegate.h"


@interface TJMBaiduMapViewController ()<BMKLocationServiceDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate,BMKMapViewDelegate>
{
    BMKLocationService *_locService;
}

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSMutableArray *annotationArray;
@end

@implementation TJMBaiduMapViewController
#pragma  mark - lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        self.mapView = [[BMKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//跟随模式
        _mapView.zoomLevel = 15;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        self.appDelegate = TJMAppDelegate;
    }
    return _appDelegate;
}
- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        self.annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}
#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.appDelegate startBaiduMapEngine];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    [self.view addSubview:self.mapView];
    [self.appDelegate startBaiduMapNaviServicesWithResult:^(BOOL isOK) {
        if (isOK) {
            //[self startNavi];
        }
    }];
    //[self startNavi];
    
    
    
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //TJMLog(@"heading is %@",userLocation.heading);
    [self.mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    TJMLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [TJMRequestH getFreeManCoordinateNearByWithCoordinate:userLocation.location.coordinate withType:TJMFreeManLocationNearby success:^(id successObj,NSString *msg) {
        [self addAnnotationWithModel:successObj];
    } fail:^(NSString *failString) {
        
    }];
    
}




#pragma  mark - 标注

#pragma  mark 添加点
- (void)addAnnotationWithModel:(TJMLocationData *)locationData {
    [self.mapView removeAnnotations:self.annotationArray];
    [self.annotationArray removeAllObjects];
//    for (TJMLocation *location in locationData.data) {
        // 添加一个PointAnnotation
        //创建大头针模型，用mapView来添加
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
//        coor.latitude = [location.lat doubleValue];
//        coor.longitude = [location.lng doubleValue];
    coor.latitude = 26.05100;
    coor.longitude = 119.23425;
        annotation.coordinate = coor;
//        annotation.title = location.userId.description;
    annotation.title = @"哈哈";
    [self.annotationArray addObject:annotation];
        [_mapView addAnnotations:_annotationArray];
//    }
}
#pragma  mark - mapView delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    //重用版
    static NSString *identifier = @"myAnnotation";
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //如果找不到，再创建
        if (!newAnnotationView) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        newAnnotationView.image = [UIImage imageNamed:@"category_1"];
        newAnnotationView.annotation = annotation;
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.centerOffset = CGPointMake(0, -newAnnotationView.image.size.height/2);
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma  mark - 导航
#pragma  mark 进行路径规划
#warning 方法需完善终点
//发起导航
- (void)startNavi {

    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
    
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    //获取当前位置
    startNode.pos.x = _locService.userLocation.location.coordinate.longitude;
    startNode.pos.y = _locService.userLocation.location.coordinate.latitude;
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
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
    
}
#pragma mark 算路成功回调,开启导航
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    TJMLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

- (void)searchDidFinished:(NSDictionary*)userInfo {
    TJMLog(@"算路失败");
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
