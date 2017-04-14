//
//  ProvinceData.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/14.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "ProvinceData.h"

@implementation ProvinceData

+ (NSDictionary *)objectClassInArray {
    return @{
             @"data" : @"Province"
             };
}

@end

@implementation Province

+ (NSDictionary *)objectClassInArray {
    return @{
             @"cities" : @"City"
             };
}
@end

@implementation City

+ (NSDictionary *)objectClassInArray {
    return @{
             @"areas" : @"Area"
             };
}
@end

@implementation Area



@end
