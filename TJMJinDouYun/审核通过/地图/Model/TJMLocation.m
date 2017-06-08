//
//  TJMLocation.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/31.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMLocation.h"

@implementation TJMLocation

- (instancetype)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D title:(NSString *)title {
    if (self = [super init]) {
        self.coordinate2D = coordinate2D;
        self.title = title;
    }
    return self;
}
@end
