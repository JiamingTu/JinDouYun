//
//  TJMLocationData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/21.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMLocationData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@interface TJMLocation : NSObject

@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,strong) NSNumber *userId;

@end
