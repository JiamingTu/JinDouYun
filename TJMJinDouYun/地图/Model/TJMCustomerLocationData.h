//
//  TJMCustomerLocationData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMCustomerLocationData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@interface TJMCustomerLocation : NSObject

@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSNumber *lat;
@property (nonatomic,strong) NSNumber *lng;

@end
