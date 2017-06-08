//
//  TJMPersonInfoModel.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMPersonInfoModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *idCard;
@property (nonatomic,strong) NSString *photo;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *status;


@end
