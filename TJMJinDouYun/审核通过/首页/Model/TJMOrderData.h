//
//  TJMOrderData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/12.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJMOrderModel;
@interface TJMOrderData : NSObject

@property (nonatomic,copy) NSArray<TJMOrderModel *> *content;
@property (nonatomic,assign) BOOL last;
@property (nonatomic,strong) NSNumber *totalPages;
@property (nonatomic,strong) NSNumber *totalElements;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,strong) NSNumber *numberOfElements;
@property (nonatomic,assign) BOOL first;
@property (nonatomic,strong) NSNumber *size;
@property (nonatomic,strong) NSNumber *number;



@end


@class TJMOrderItem;

@interface TJMOrderModel : NSObject<BMKRouteSearchDelegate>

@property (nonatomic,strong) NSNumber *orderId;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,strong) NSNumber *orderStatus;
@property (nonatomic,assign) BOOL timeOut;
@property (nonatomic,assign) BOOL comment;
@property (nonatomic,strong) TJMCity *city;
@property (nonatomic,strong) NSNumber *createTime;
@property (nonatomic,strong) NSNumber *pairTime;
@property (nonatomic,strong) NSNumber *pickUpTime;
@property (nonatomic,strong) NSNumber *finishTime;
@property (nonatomic,strong) NSNumber *requestTime;
@property (nonatomic,strong) NSNumber *deliveryTime;
@property (nonatomic,strong) TJMOrderItem *item;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,strong) NSNumber *objectValue;
@property (nonatomic,strong) NSNumber *objectWeight;
@property (nonatomic,strong) TJMVehicle *tool;
@property (nonatomic,copy) NSString *coupon;
@property (nonatomic,strong) NSNumber *estimateTime;
@property (nonatomic,strong) NSNumber *estimateMoney;
@property (nonatomic,strong) NSNumber *distance;
@property (nonatomic,copy) NSString *carrier;
@property (nonatomic,strong) NSNumber *payType;
@property (nonatomic,strong) NSNumber *payStatus;
@property (nonatomic,strong) NSNumber *orderMoney;
@property (nonatomic,strong) NSNumber *freeMoney;
@property (nonatomic,strong) NSNumber *carryMoney;
@property (nonatomic,strong) NSNumber *carryFee;
@property (nonatomic,strong) NSNumber *actualMoney;
@property (nonatomic,strong) NSNumber *markUpMoney;
@property (nonatomic,copy) NSString *consignerName;
@property (nonatomic,copy) NSString *consignerMobile;
@property (nonatomic,copy) NSString *receiverName;
@property (nonatomic,copy) NSString *receiverMobile;
@property (nonatomic,strong) NSNumber *consignerLng;
@property (nonatomic,strong) NSNumber *consignerLat;
@property (nonatomic,strong) NSNumber *receiverLng;
@property (nonatomic,strong) NSNumber *receiverLat;
@property (nonatomic,copy) NSString *consignerAddress;
@property (nonatomic,copy) NSString *receiverAddress;
@property (nonatomic,strong) NSNumber *version;
@property (nonatomic,copy) NSString *codeUrl;
@property (nonatomic,copy) NSString *perpayId;
@property (nonatomic,assign) BOOL atOnce;//1:及时取 0:预约货
@property (nonatomic,copy) NSString *carrierShowMoney;
//计算后得到

@property (nonatomic,strong) NSNumber *getDistance;
//@property (nonatomic,copy) RouteResultBolck routeResult;
@end


@interface TJMOrderItem : NSObject

@property (nonatomic,strong) NSNumber *itemId;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,assign) BOOL enable;


@end

