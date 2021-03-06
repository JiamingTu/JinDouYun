//
//  TJMBaiduMapViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBaiduMapViewController.h"
#import "AppDelegate.h"

@interface TJMBaiduMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>
{
    
    BMKMapView *_mapView;
}
@property (nonatomic,strong) BMKRouteSearch *routeSearch;
@property (nonatomic,strong) BMKLocationService *locServiceForMap;

@property (nonatomic,strong) NSMutableArray *annotationArray;
//起点和终点
@property (nonatomic,strong) TJMLocation *consignerLoc;
@property (nonatomic,strong) TJMLocation *reciverLoc;
//热力图数据
@property (nonatomic,strong) TJMHeatMapData *heatMapData;
@end

@implementation TJMBaiduMapViewController
#pragma  mark - lazy loading
- (BMKLocationService *)locServiceForMap {
    if (!_locServiceForMap) {
        //初始化BMKLocationService
        self.locServiceForMap = [[BMKLocationService alloc]init];
        //        //每移动100米 就调用一次代理
        _locServiceForMap.distanceFilter = 100;
        _locServiceForMap.pausesLocationUpdatesAutomatically = NO;
        _locServiceForMap.delegate = self;
    }
    return _locServiceForMap;
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

- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        self.annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}
- (TJMLocation *)consignerLoc {
    if (!_consignerLoc) {
        self.consignerLoc = self.locations[0];
    }
    return _consignerLoc;
}
- (TJMLocation *)reciverLoc {
    if (!_reciverLoc) {
        self.reciverLoc = self.locations[1];
    }
    return _reciverLoc;
}



#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化位置服务

    [self.locServiceForMap startUserLocationService];
    _mapView = [TJMLocationService sharedLocationService].mapView;
    _mapView.delegate = self;
    //判断查看地图 还是热力图
    if (self.locations) {
        _mapView.frame = CGRectMake(0, 64, TJMScreenWidth, TJMScreenHeight - 64);
        //设置首页标题等
        [self setTitle:@"查看地图" fontSize:17 colorHexValue:0x333333];
        [self setBackNaviItem];
        [self addAnnotationWithLocations];
        [self showDriveSearch];
        
    } else {
        _mapView.frame = CGRectMake(0, 64, TJMScreenWidth, TJMScreenHeight - 64 - 49);
//        //获取热力图数据
        NSString *cityName = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMCityName];
        [TJMRequestH heatMapDataSuccessWithDay:7 cityName:cityName success:^(id successObj, NSString *msg) {
            self.heatMapData = successObj;
            //添加热力图
            [self addHeatMapWithHeatMapData:successObj];
        } fail:^(NSString *failString) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:failString];
        }];
    }
    //添加百度地图视图
    [self.view addSubview: _mapView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routeSearch.delegate = self;
    _locServiceForMap.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routeSearch.delegate = nil;
    _locServiceForMap.delegate = nil;
}

- (void)dealloc {
    [_locServiceForMap stopUserLocationService];
    [_mapView removeHeatMap];
    NSArray *array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    [_mapView removeAnnotations:_annotationArray];
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    
}

#pragma  mark - 返回按钮
- (void)itemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //TJMLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    if (self.locations) {
        TJMLocation *myLocation = [[TJMLocation alloc]initWithCoordinate2D:userLocation.location.coordinate title:@"我的位置"];
        [self mapViewFitAnnotations:@[self.reciverLoc,self.consignerLoc,myLocation]];
    } else {
        if (self.heatMapData.data.count == 0) {
            [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        } else {
            [self mapViewFitHeatMapData:self.heatMapData andUserLocation:userLocation];
        }
    }
}


#pragma  mark - 标注
#pragma  mark 添加点
- (void)addAnnotationWithLocations {
    [_mapView removeAnnotations:self.annotationArray];
    [self.annotationArray removeAllObjects];
    [self.locations enumerateObjectsUsingBlock:^(TJMLocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 添加一个PointAnnotation
        //创建大头针模型，用mapView来添加
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = obj.coordinate2D;
//        annotation.title = @"哈哈";
        [self.annotationArray addObject:annotation];
    }];
    [_mapView addAnnotations:_annotationArray];
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
        if ([self.annotationArray indexOfObject:annotation] == 0) {
            //起点
            newAnnotationView.image = [UIImage imageNamed:@"position_g"];
        } else {
            newAnnotationView.image = [UIImage imageNamed:@"position_r"];
        }
        newAnnotationView.annotation = annotation;
        newAnnotationView.centerOffset = CGPointMake(0, -newAnnotationView.image.size.height/2);
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
#pragma  mark - 自适应 显示
- (void)mapViewFitAnnotations:(NSArray<TJMLocation *> *)annos
{
    if (annos.count < 2) return;
    
    CLLocationCoordinate2D coor = [annos[0] coordinate2D];
    BMKMapPoint pt = BMKMapPointForCoordinate(coor);
    
    CGFloat ltX, ltY, rbX, rbY;
    
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    
    for (int i = 1; i < annos.count; i++) {
        CLLocationCoordinate2D coor = [annos[i] coordinate2D];
        BMKMapPoint pt = BMKMapPointForCoordinate(coor);
        if (pt.x < ltX) ltX = pt.x;
        if (pt.x > rbX) rbX = pt.x;
        if (pt.y > ltY) ltY = pt.y;
        if (pt.y < rbY) rbY = pt.y;
    }
    
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
- (void)mapViewFitHeatMapData:(TJMHeatMapData *)data andUserLocation:(BMKUserLocation *)location {
    if (data.data.count < 2) return;
    
    CLLocationCoordinate2D coor = location.location.coordinate;
    
    BMKMapPoint pt = BMKMapPointForCoordinate(coor);
    
    CGFloat ltX, ltY, rbX, rbY;
    
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    
    for (int i = 0; i < data.data.count; i++) {
        CLLocationCoordinate2D coor;
        TJMHeatMapModel *model = data.data[i];
        coor.latitude = model.consignerLat.floatValue;
        coor.longitude = model.consignerLng.floatValue;
        BMKMapPoint pt = BMKMapPointForCoordinate(coor);
        if (pt.x < ltX) ltX = pt.x;
        if (pt.x > rbX) rbX = pt.x;
        if (pt.y > ltY) ltY = pt.y;
        if (pt.y < rbY) rbY = pt.y;
    }
    
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma  mark - 进行路径规划
#pragma mark 驾车路线
-(void)showDriveSearch{
    
    //线路检索节点信息
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = self.consignerLoc.coordinate2D;
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    CLLocationCoordinate2D endCoordinate = self.reciverLoc.coordinate2D;
    end.pt = endCoordinate;
    BMKRidingRoutePlanOption *ridingRoutePlanOption = [[BMKRidingRoutePlanOption alloc]init];
    ridingRoutePlanOption.from = start;
    ridingRoutePlanOption.to = end;
    BOOL flag = [self.routeSearch ridingSearch:ridingRoutePlanOption];
    if (flag) {
        
    }
}

#pragma mark 返回驾乘搜索结果
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray *array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        //表示一条驾车路线
        BMKRidingRouteLine *plan = (BMKRidingRouteLine *)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
//            //表示驾车路线中的一个路段
            BMKDrivingStep * transitStep = [plan.steps objectAtIndex:i];
            
//            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }

        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k = 0; k < transitStep.pointsCount; k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
         //通过points构建BMKPolyline
        BMKPolyline * polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;

    }
}

#pragma mark 根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}

#pragma  mark - 热力图
//添加热力图
-(void)addHeatMapWithHeatMapData:(TJMHeatMapData *)data{
    //创建热力图数据类
    BMKHeatMap* heatMap = [[BMKHeatMap alloc]init];
    //创建渐变色类
    UIColor * color1 = [UIColor blueColor];
    UIColor * color2 = [UIColor yellowColor];
    UIColor * color3 = [UIColor redColor];
    NSArray *colorInitialArray = [[NSArray alloc]initWithObjects:color1,color2,color3, nil];
    BMKGradient* gradient = [[BMKGradient alloc]initWithColors:colorInitialArray startPoints:@[@"0.08f", @"0.4f", @"1f"]];
    //如果用户自定义了渐变色则按自定义的渐变色进行绘制否则按默认渐变色进行绘制
    heatMap.mGradient = gradient;
    NSMutableArray *coorArray = [NSMutableArray array];
    //创建热力图数据数组
    for(int i = 0; i < data.data.count; i++)
    {
        TJMHeatMapModel *model = data.data[i];
        //创建BMKHeatMapNode
        BMKHeatMapNode* heapmapnode_test = [[BMKHeatMapNode alloc]init];
        //此处示例为随机生成的坐标点序列，开发者使用自有数据即可
        CLLocationCoordinate2D coor;
        coor.latitude = model.consignerLat.floatValue;
        coor.longitude = model.consignerLng.floatValue;
        heapmapnode_test.pt = coor;
        //随机生成点强度
//        heapmapnode_test.intensity = 900;
        //添加BMKHeatMapNode到数组
        [coorArray addObject:heapmapnode_test];
    }
    //将点数据赋值到热力图数据类
    heatMap.mData = coorArray;
    heatMap.mRadius = 24;
    //适应地图显示范围
    if (_locServiceForMap.userLocation.location) {
        [self mapViewFitHeatMapData:data andUserLocation:_locServiceForMap.userLocation];
    }
    //调用mapView中的方法根据热力图数据添加热力图
    [_mapView addHeatMap:heatMap];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 是否是正在使用的视图
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
