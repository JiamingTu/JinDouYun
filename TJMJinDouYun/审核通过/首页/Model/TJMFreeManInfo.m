//
//  TJMFreeManInfo.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/10.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMFreeManInfo.h"

@implementation TJMFreeManInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}





@end
