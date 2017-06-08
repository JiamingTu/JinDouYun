//
//  TJMPerformanceModel.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/2.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPerformanceModel.h"

@implementation TJMPerformanceModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

@end
