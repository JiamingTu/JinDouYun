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
    return @[@"getDistance",@"routeResult"];
}

#pragma mark 返回驾乘搜索结果
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine *plan = (BMKRidingRouteLine *)[result.routes firstObject];
        // 计算路线方案中的路段数目
        self.getDistance = @(plan.distance / 1000.0);
        NSString *notiKey = [NSString stringWithFormat:@"%p",self];
        [[NSNotificationCenter defaultCenter] postNotificationName:notiKey object:nil userInfo:@{@"model":self}];
    }
}



@end

@implementation TJMOrderItem



@end
