//
//  TJMBankData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/23.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMBankData : NSObject

@property (nonatomic,copy) NSArray *data;


@end

@interface TJMBankModel : NSObject

@property (nonatomic,strong) NSNumber *bankId;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *bankIcon;
@property (nonatomic,assign) BOOL enabled;

@end
