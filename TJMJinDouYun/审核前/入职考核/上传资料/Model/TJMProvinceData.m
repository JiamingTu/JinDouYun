//
//  TJMProvinceData.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMProvinceData.h"

@implementation TJMProvinceData

+ (NSDictionary *)objectClassInArray {
    return @{
             @"data" : @"TJMProvince"
             };
}

- (void)deleteDisableProvince {
    NSMutableArray *newData = [NSMutableArray array];
    for (TJMProvince *province in self.data) {
        if (province.enable == YES) {
            //查找城市
            [province deleteDisableCity];
            //加入数组
            [newData addObject:province];
        }
    }
    self.data = newData;
}

@end

@implementation TJMProvince

+ (NSDictionary *)objectClassInArray {
    return @{
             @"cities" : @"TJMCity"
             };
}

- (void)deleteDisableCity {
    NSMutableArray *newCities = [NSMutableArray array];
    for (TJMCity *city in self.cities) {
        if (city.enable == YES) {
            //查找区域
            [city deleteDisableArea];
            //加入数组
            [newCities addObject:city];
        }
    }
    self.cities = newCities;
}

@end

@implementation TJMCity

+ (NSDictionary *)objectClassInArray {
    return @{
             @"areas" : @"TJMArea"
             };
}

- (void)deleteDisableArea {
    NSMutableArray *newAreas = [NSMutableArray array];
    for (TJMArea *area in self.areas) {
        if (area.enable == YES) {
            [newAreas addObject:area];
        }
    }
    self.areas = newAreas;
}

@end

@implementation TJMArea



@end
