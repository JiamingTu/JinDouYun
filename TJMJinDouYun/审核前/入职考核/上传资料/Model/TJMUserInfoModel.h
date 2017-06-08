//
//  TJMUserInfoModel.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TJMUserInfoTypeUploadInfo,
    TJMUserInfoTyptBindingBankCard,
} TJMUserInfosType;

@interface TJMUserInfoModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,assign) BOOL isTextField;
@property (nonatomic,copy) NSString *inputType;
@property (nonatomic,copy) NSString *inputValue;

@end

@interface TJMUserInfos : NSObject

- (instancetype)initWithInfoType:(TJMUserInfosType)type;

@property (nonatomic,copy) NSArray *infos;

@end
