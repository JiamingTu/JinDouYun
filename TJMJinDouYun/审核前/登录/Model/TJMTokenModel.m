//
//  TJMTokenModel.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTokenModel.h"

@implementation TJMTokenModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.token = dictionary[@"token"];
        self.userId = dictionary[@"userId"];
        self.createDate = [NSDate date];
    }
    return self;
}

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
