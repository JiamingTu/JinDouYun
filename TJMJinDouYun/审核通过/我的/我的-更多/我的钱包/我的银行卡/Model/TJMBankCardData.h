//
//  TJMBankCardData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/22.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMBankCardData : NSObject

@property (nonatomic,copy) NSArray *data;

@end

@class TJMBankModel;
@interface TJMBankCardModel : NSObject

@property (nonatomic,strong) TJMBankModel *bank;
@property (nonatomic,strong) NSNumber *bankcard;
@property (nonatomic,strong) NSNumber *carrierId;
@property (nonatomic,strong) NSNumber *createTime;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,strong) NSNumber *carrierCardId;
@end
