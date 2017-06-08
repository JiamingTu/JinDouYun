//
//  TJMTradingRecordData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/7.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMTradingRecordData : NSObject

@property (nonatomic,strong) NSArray *content;
@property (nonatomic,strong) NSNumber *first;
@property (nonatomic,strong) NSNumber *last;
@property (nonatomic,strong) NSNumber *number;
@property (nonatomic,strong) NSNumber *numberOfElements;
@property (nonatomic,strong) NSNumber *size;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,strong) NSNumber *totalElements;
@property (nonatomic,strong) NSNumber *totalPages;


@end

@interface TJMTradingRecordModel : NSObject

@property (nonatomic,copy) NSString *afterMoney;
@property (nonatomic,strong) NSNumber *carrierAccountId;
@property (nonatomic,strong) NSNumber *carrierId;
@property (nonatomic,strong) NSNumber *createTime;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,assign) BOOL positive;


@end
