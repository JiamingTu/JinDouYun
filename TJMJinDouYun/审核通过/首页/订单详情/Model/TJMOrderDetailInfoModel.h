//
//  TJMOrderDetailInfoModel.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/1.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMOrderDetailInfoModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign) BOOL isTel;
@property (nonatomic,assign) BOOL isBigerFont;

@end

@interface TJMOrderDetailData : NSObject

@property (nonatomic,copy) NSArray *data;

- (instancetype)initWithOrderModel:(TJMOrderModel *)orderModel;
@end
