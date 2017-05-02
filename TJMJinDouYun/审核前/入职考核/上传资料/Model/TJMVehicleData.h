//
//  TJMVehicleData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMVehicleData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@interface TJMVehicle : NSObject

@property (nonatomic,strong) NSNumber *enable;
@property (nonatomic,copy) NSString *pickTime;
@property (nonatomic,strong) NSNumber  *speed;
@property (nonatomic,strong) NSNumber *toolId;
@property (nonatomic,strong) NSString *toolName;

@end
