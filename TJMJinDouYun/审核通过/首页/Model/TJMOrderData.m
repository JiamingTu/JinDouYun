//
//  TJMOrderData.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/12.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMOrderData.h"

@implementation TJMOrderData

+ (NSDictionary *)objectClassInArray {
    return @{
             @"content" : @"TJMOrderModel"
             };
}

@end

@implementation TJMOrderModel

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"getDistance"];
}




@end

@implementation TJMOrderItem



@end
