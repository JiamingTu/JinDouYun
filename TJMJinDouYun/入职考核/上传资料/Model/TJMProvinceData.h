//
//  TJMProvinceData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMProvinceData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@interface TJMProvince : NSObject

@property (nonatomic,copy) NSArray *cities;
@property (nonatomic,strong) NSNumber *enable;
@property (nonatomic,strong) NSNumber *provinceCode;
@property (nonatomic,strong) NSNumber *provinceId;
@property (nonatomic,strong) NSString *provinceName;

@end

@interface TJMCity : NSObject

@property (nonatomic,copy) NSArray *areas;
@property (nonatomic,strong) NSNumber *cityCode;
@property (nonatomic,strong) NSNumber *cityId;
@property (nonatomic,strong) NSNumber *enable;
@property (nonatomic,copy) NSString *cityName;


@end

@interface TJMArea : NSObject

@property (nonatomic,strong) NSNumber *areaCode;
@property (nonatomic,strong) NSNumber *areaId;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,strong) NSNumber *enable;

@end
