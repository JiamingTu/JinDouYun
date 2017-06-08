//
//  TJMHeatMapData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/6.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMHeatMapData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@interface TJMHeatMapModel : NSObject

@property (nonatomic,copy) NSString *consignerLat;
@property (nonatomic,copy) NSString *consignerLng;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
