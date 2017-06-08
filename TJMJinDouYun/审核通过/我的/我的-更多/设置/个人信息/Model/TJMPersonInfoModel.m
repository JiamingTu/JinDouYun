//
//  TJMPersonInfoModel.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPersonInfoModel.h"

@implementation TJMPersonInfoModel

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
