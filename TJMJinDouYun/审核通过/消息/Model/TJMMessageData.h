//
//  TJMMessageData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/5.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJMMessageModel;
@interface TJMMessageData : NSObject


@property (nonatomic,copy) NSArray<TJMMessageModel *> *data;

@end

@interface TJMMessageModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,strong) NSNumber *messageCenterId;
@property (nonatomic,copy) NSString *mobile;
//@property (nonatomic,copy) NSArray *receivers;
@property (nonatomic,strong) NSNumber *sort;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,assign) BOOL read;//是否已读

@end

//@interface TJMReceiver : NSObject<NSCoding>
//
//@end
