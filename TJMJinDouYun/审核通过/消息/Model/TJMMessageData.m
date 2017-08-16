//
//  TJMMessageData.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/5.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMessageData.h"

@implementation TJMMessageData

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data":@"TJMMessageModel"};
}

@end

@implementation TJMMessageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"receivers":@"TJMReceiver"};
}

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

//@implementation TJMReceiver
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        [self mj_decode:aDecoder];
//    }
//    return self;
//}
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self mj_encode:aCoder];
//}
//
//@end
