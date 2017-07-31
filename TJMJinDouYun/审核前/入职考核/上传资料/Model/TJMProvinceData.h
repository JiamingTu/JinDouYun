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

- (void)deleteDisableProvince;
@end

@interface TJMProvince : NSObject

@property (nonatomic,copy) NSArray *cities;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,strong) NSNumber *provinceCode;
@property (nonatomic,strong) NSNumber *provinceId;
@property (nonatomic,strong) NSString *provinceName;

- (void)deleteDisableCity;
@end

@interface TJMCity : NSObject

@property (nonatomic,copy) NSArray *areas;
@property (nonatomic,strong) NSNumber *cityCode;
@property (nonatomic,strong) NSNumber *cityId;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,copy) NSString *cityName;

- (void)deleteDisableArea;

@end

@interface TJMArea : NSObject

@property (nonatomic,strong) NSNumber *areaCode;
@property (nonatomic,strong) NSNumber *areaId;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,assign) BOOL enable;

@end
