//
//  TJMFreeManInfo.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/10.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMFreeManInfo : NSObject<NSCoding>

@property (nonatomic,copy) NSString *area;
@property (nonatomic,strong) NSNumber *carrierId;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *concact;
@property (nonatomic,copy) NSString *concactMobile;
@property (nonatomic,strong) NSNumber *createTime;
@property (nonatomic,strong) NSNumber *examStatus;
@property (nonatomic,copy) NSString *inviteCode;
@property (nonatomic,strong) NSNumber *lastLoginTime;
@property (nonatomic,strong) NSNumber *materialStatus;
@property (nonatomic,strong) NSNumber *mobile;
@property (nonatomic,strong) NSNumber *money;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,strong) NSNumber *score;
@property (nonatomic,copy) NSString *tool;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,strong) NSNumber *workStatus;



@end
