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

@end

@implementation TJMProvince

+ (NSDictionary *)objectClassInArray {
    return @{
             @"cities" : @"TJMCity"
             };
}
@end

@implementation TJMCity

+ (NSDictionary *)objectClassInArray {
    return @{
             @"areas" : @"TJMArea"
             };
}
@end

@implementation TJMArea



@end
