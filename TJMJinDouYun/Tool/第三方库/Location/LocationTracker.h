//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

typedef void(^UpdateFreeManLocation)(CLLocationCoordinate2D coordinate);

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocationCoordinate2D;
@property (nonatomic,strong) CLLocation *myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;



+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;

@property (nonatomic,copy) UpdateFreeManLocation updateFreeManLoc;
@property (nonatomic,copy) UpdateFreeManLocation didUpdateFreeManLoc;

@property (nonatomic,assign) BOOL isFirstUpdateLoc;

@end
