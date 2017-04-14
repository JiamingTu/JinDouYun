//
//  TJMTokenModel.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMTokenModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSDate *createDate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
