//
//  TJMLocationService.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMLocationService.h"
#import "LocationTracker.h"
#import <MapKit/MapKit.h>
@interface TJMLocationService ()<BMKLocationServiceDelegate,BNNaviRoutePlanDelegate,BMKGeoCodeSearchDelegate,BNNaviUIManagerDelegate,BMKRouteSearchDelegate>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    BOOL _baiduMapEngineStatus;
    BMKUserLocation *_myLocation;
}

@property (nonatomic,strong) AppDelegate *appDelegate;

//定时上传定位
@property (nonatomic,strong) NSTimer *updateLocTimer;
@property (nonatomic,strong) NSThread *updateLocThread;
@property (nonatomic,strong) LocationTracker *locationTracker;

@end

@implementation TJMLocationService
#pragma  mark - lazy loading
- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        self.appDelegate = TJMAppDelegate;
    }
    return _appDelegate;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, TJMScreenWidth, TJMScreenHeight - 64)];
        _mapView.showsUserLocation = YES;
//        _mapView.delegate = self;
        _mapView.userTrackingMode = BMKUserTrackingModeHeading;//跟随模式
        _mapView.zoomLevel = 15;
    }
    return _mapView;
}
- (BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        //反编码获得城市名
        self.searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (BMKRouteSearch *)routeSearch {
    if (!_routeSearch) {
        //初始化检索对象
        self.routeSearch = [[BMKRouteSearch alloc] init];
        //设置delegate，用于接收检索结果
        _routeSearch.delegate = self;
    }
    return _routeSearch;
}


#pragma  mark 位置服务
- (LocationTracker *)locationTracker {
    if (!_locationTracker) {
        self.locationTracker = [[LocationTracker alloc]init];
        _locationTracker.updateFreeManLoc = ^(CLLocationCoordinate2D coordinate){
            [TJMRequestH updateFreeManLocationWithCoordinate:coordinate withType:TJMUploadFreeManLocation success:^(id successObj, NSString *msg) {
                
            } fail:^(NSString *failString) {
                
            }];
        };
    }
    return _locationTracker;
}

#pragma  mark singleton
SingletonM(LocationService)

#pragma  mark - 配置百度地图
#pragma  mark 打开引擎
- (void)startBaiduMapEngine {
    //在您的AppDelegate.m文件中添加对BMKMapManager的初始化，并填入您申请的授权Key
    // 要使用百度地图，请先启动BaiduMapManager
    if (!_mapManager) {
        _mapManager = [[BMKMapManager alloc]init];
    }
    if (!_baiduMapEngineStatus) {
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        BOOL ret = [_mapManager start:TJMBaiduMapAK  generalDelegate:self];
        if (!ret) {
            TJMLog(@"manager start failed!");
        }
    }
    
}
#pragma  mark 关闭引擎
//- (void)stopBaiduMapEngine {
//    BOOL ret = [_mapManager stop];
//    if (!ret) {
//        TJMLog(@"manager stop failed!");
//    }
//}
#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError {
    if (iError == 0) {
        TJMLog(@"网络正常");
        _baiduMapEngineStatus = 1;
    }else {
        TJMLog(@"网络出错,%@",@(iError));
        _baiduMapEngineStatus = 0;
    }
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参考BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError {
    if (iError == 0) {
        TJMLog(@"验证成功");
        _baiduMapEngineStatus = 1;
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        //        //每移动100米 就调用一次代理
        //        _locService.distanceFilter = 100;
        _locService.pausesLocationUpdatesAutomatically = NO;
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
    }else {
        TJMLog(@"验证失败,%d",iError);
        _baiduMapEngineStatus = 0;
    }
}


- (void)getFreeManLocationWith:(TJMGetLocationType)type target:(CLLocationCoordinate2D)coordinate {
    [self startBaiduMapEngine];
    self.targetCoordinate = coordinate;
    self.getLocationType = type;
    if (_locService) {
        [_locService startUserLocationService];
    }
}



#pragma  mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    switch (self.getLocationType) {
        case TJMGetLocationTypeCityName:
        {
            //获取城市名字
            _myLocation = userLocation;
            [self locationCurrentCityWithUserLocation:userLocation.location.coordinate];
        }
            break;
        case TJMGetLocationTypeLocation:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTJMLocationDidChange object:nil userInfo:@{@"myLocation":userLocation}];
        }
            break;
        case TJMGetLocationTypeNaviService:
        {
            //导航
            [self routePlanFromMyLocation:userLocation.location.coordinate toGetLocation:self.targetCoordinate];
        }
            break;
            
        default:
            break;
    }
    [_locService stopUserLocationService];
}
#pragma  mark 定位失败后
- (void)didFailToLocateUserWithError:(NSError *)error {
    
}

#pragma  mark - 获取城市名字
- (void)locationCurrentCityWithUserLocation:(CLLocationCoordinate2D)coordinate {
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
        TJMLog(@"反geo检索发送成功");
    } else {
        TJMLog(@"反geo检索发送失败");
    }
}
#pragma  mark BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        TJMLog(@"%@",result.addressDetail.city);
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kTJMLocationCityNameDidChange object:nil userInfo:@{@"cityName":result.addressDetail.city,@"myLocation":_myLocation}];
        [TJMSandBoxManager saveInInfoPlistWithModel:result.addressDetail.city key:kTJMCityName];
    } else {
        TJMLog(@"抱歉，未找到结果");
    }
}


#pragma  mark 导航路算
- (void)routePlanFromMyLocation:(CLLocationCoordinate2D)mineLoc toGetLocation:(CLLocationCoordinate2D)getLoc {
    //开启导航
    [self.appDelegate startBaiduMapNaviServicesWithResult:^(BOOL isOK) {
        
        if (isOK) {
            NSMutableArray *nodesArray = [[NSMutableArray alloc] initWithCapacity: 2];
            //起点
            BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
            startNode.pos = [[BNPosition alloc] init];
            startNode.pos.x = mineLoc.longitude;
            startNode.pos.y = mineLoc.latitude;
            startNode.pos.eType = BNCoordinate_BaiduMapSDK;
            [nodesArray addObject:startNode];
            
            //终点
            BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
            endNode.pos = [[BNPosition alloc] init];
            endNode.pos.x = getLoc.longitude;
            endNode.pos.y = getLoc.latitude;
            endNode.pos.eType = BNCoordinate_BaiduMapSDK;
            [nodesArray addObject:endNode];
            // 发起算路
            [BNCoreServices_RoutePlan  startNaviRoutePlan: BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
            [TJMHUDHandle hiddenHUDForView:[self.appDelegate topViewController].view];
        }
    }];
}
#pragma  mark 路算完成后回调
- (void)routePlanDidFinished:(NSDictionary *)userInfo {
    TJMLog(@"路算成功");
    //显示导航UI
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];

}
//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    TJMLog(@"算路失败");
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            TJMLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            TJMLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            TJMLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            TJMLog(@"起终点距离起终点太近");
            break;
        default:
            TJMLog(@"算路失败");
            break;
    }
}
#pragma  mark - BNNaviUIManagerDelegate
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo {
    [self.appDelegate stopBaiduMapNaviServices];
}




#pragma  mark - 定时上传定位
#pragma  mark 
-(void)setUpLocationTrakerWithWorkStatus:(BOOL)isOn timeInterval:(NSTimeInterval)timeInterval {
    [self cancelTiemr];
    if (isOn) {
        [self.locationTracker startLocationTracking];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationTracker updateLocationToServer];
        });
        //开启计时器
        [self startLocationTimerWithTimeInterval:timeInterval];
    }
    
    
}
#pragma  mark 开启定时器
- (void)startLocationTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    //如果timer还存在（没有停止），那就不重新创建子线程 和 timer 了
    if (!self.updateLocTimer) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.updateLocThread = [NSThread currentThread];
                [strongSelf.updateLocThread setName:@"updateLocThread"];
                strongSelf.updateLocTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:strongSelf selector:@selector(locTimerAction:) userInfo: nil repeats:YES];
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:strongSelf.updateLocTimer forMode:NSDefaultRunLoopMode];
                [runloop run];
            }
        });
    }
}
#pragma  mark 定时器绑定方法
- (void)locTimerAction:(NSTimer *)timer {
    //上传定位信息
    [self.locationTracker updateLocationToServer];
}
#pragma  mark 销毁定时器
- (void)cancel{
    if (self.updateLocTimer) {
        [self.updateLocTimer invalidate];
        self.updateLocTimer = nil;
    }
}
//需在开启的线程中销毁
- (void)cancelTiemr {
    if (self.updateLocTimer && self.updateLocThread) {
        [self performSelector:@selector(cancel) onThread:self.updateLocThread withObject:nil waitUntilDone:YES];
    }
}

#pragma  mark - 进行路径规划
#pragma  mark 计算两点大致距离
- (CLLocationDistance)calculateDistanceFromMyLocation:(CLLocationCoordinate2D)mineLoc toGetLocation:(CLLocationCoordinate2D)getLoc {
    CLLocation *fromLoc = [[CLLocation alloc]initWithLatitude:mineLoc.latitude longitude:mineLoc.longitude];
    CLLocation *toLoc = [[CLLocation alloc]initWithLatitude:getLoc.latitude longitude:getLoc.longitude];
    CLLocationDistance distance = [fromLoc distanceFromLocation:toLoc];
    return distance;
}


#pragma mark 驾车路线
-(void)calculateDriveDistanceWithStartPoint:(CLLocationCoordinate2D)startCoordinate endPoint:(CLLocationCoordinate2D)endCoordinate {
    //线路检索节点信息
//    BMKPlanNode *start = [[BMKPlanNode alloc] init];
//    start.pt = startCoordinate;
//    BMKPlanNode *end = [[BMKPlanNode alloc] init];
//    end.pt = endCoordinate;
//    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc] init];
//    drivingRouteSearchOption.from = start;
//    drivingRouteSearchOption.to = end;
//    TJMLog(@"计算驾车路线------------%@",[NSThread currentThread]);
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        BOOL flag = [self.routeSearch drivingSearch:drivingRouteSearchOption];
//        if (flag) {
//        }
//    }];
    
    //起点终点的详细信息
    MKPlacemark *startPlace = [[MKPlacemark alloc]initWithCoordinate:startCoordinate addressDictionary:nil];
    MKPlacemark *endPlace = [[MKPlacemark alloc]initWithCoordinate:endCoordinate addressDictionary:nil];
    //起点 终点的 节点
    MKMapItem *startItem = [[MKMapItem alloc]initWithPlacemark:startPlace];
    MKMapItem *endItem = [[MKMapItem alloc]initWithPlacemark:endPlace];
    
    //路线请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = startItem;
    request.destination = endItem;
    
    //发送请求
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    
    
    //计算
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        MKRoute *route = response.routes.firstObject;
        double distance = route.distance;
        if (self.routeResult) {
            self.routeResult(distance / 1000.0);
        }
    }];
    
    
}

#pragma mark 返回驾乘搜索结果
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //表示一条驾车路线
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine *)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        if (self.routeResult) {
            self.routeResult(plan.distance / 1000.0);
        }
    }
}



@end
