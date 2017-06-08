//
//  TJMLocationService.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationTracker.h"

typedef enum : NSUInteger {
    TJMGetLocationTypeLocAndCityName,
    TJMGetLocationTypeLocation,
    TJMGetLocationTypeCityName,
    TJMGetLocationTypeNaviService,
} TJMGetLocationType;

@interface TJMLocationService : NSObject<BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
}
SingletonH(LocationService)

@property (nonatomic,assign) NSInteger getLocationType;
@property (nonatomic,assign) CLLocationCoordinate2D targetCoordinate;
//获取位置信息 并进行下一步操作
- (void)getFreeManLocationWith:(TJMGetLocationType)type target:(CLLocationCoordinate2D)coordinate;
- (CLLocationDistance)calculateDistanceFromMyLocation:(CLLocationCoordinate2D)mineLoc toGetLocation:(CLLocationCoordinate2D)getLoc;

- (void)routePlanFromMyLocation:(CLLocationCoordinate2D)mineLoc toGetLocation:(CLLocationCoordinate2D)getLoc;

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKGeoCodeSearch *searcher;
@property (nonatomic,strong) BMKRouteSearch *routeSearch;


@end

