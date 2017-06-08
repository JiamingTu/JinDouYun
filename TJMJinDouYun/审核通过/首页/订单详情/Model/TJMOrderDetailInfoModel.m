//
//  TJMOrderDetailInfoModel.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/1.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMOrderDetailInfoModel.h"

@implementation TJMOrderDetailInfoModel




@end

@implementation TJMOrderDetailData

- (instancetype)initWithOrderModel:(TJMOrderModel *)orderModel {
    if (self = [super init]) {
        TJMOrderDetailInfoModel *consignerName = [self setInfoWithTitle:@"寄件人姓名" detail:orderModel.consignerName isTel:NO];
        TJMOrderDetailInfoModel *consignerTel = [self setInfoWithTitle:@"寄件人电话" detail:orderModel.consignerMobile isTel:YES];
        TJMOrderDetailInfoModel *consignerAddress = [self setInfoWithTitle:@"寄件人地址" detail:orderModel.consignerAddress isTel:NO];
        consignerAddress.detail = @"好长好长的地址好长好长的地址好长好长的地址好长好长的地址好长好长的地址好长好长的地址好长好长的地址好长好长的地址";
        NSArray *consignerArr = @[consignerName,consignerTel,consignerAddress];
        
        TJMOrderDetailInfoModel *receiverName = [self setInfoWithTitle:@"收件人姓名" detail:orderModel.receiverName isTel:NO];
        TJMOrderDetailInfoModel *receiverTel = [self setInfoWithTitle:@"收件人电话" detail:orderModel.receiverMobile isTel:YES];
        TJMOrderDetailInfoModel *receiverAddress = [self setInfoWithTitle:@"收件人地址" detail:orderModel.receiverAddress isTel:NO];
        NSArray *receiverArr = @[receiverName,receiverTel,receiverAddress];
        
        
        //物品金额
        NSString *objValueString = [NSString stringWithFormat:@"￥%@",orderModel.objectValue];
        TJMOrderDetailInfoModel *objValue = [self setInfoWithTitle:@"物品金额" detail:objValueString isTel:NO];
        //物品种类
        TJMOrderDetailInfoModel *objType = [self setInfoWithTitle:@"物品种类" detail:orderModel.item.itemName isTel:NO];
        //物品重量
        NSString *weightString = [NSString stringWithFormat:@"%@KG",orderModel.objectWeight];
        TJMOrderDetailInfoModel *objWeight = [self setInfoWithTitle:@"物品重量" detail:weightString isTel:NO];
        //订单编号
        TJMOrderDetailInfoModel *orderNo = [self setInfoWithTitle:@"订单编号" detail:orderModel.orderNo isTel:NO];
        //订单状态
        NSString *orderStatusText;
        if (orderModel.orderStatus.integerValue == 2) orderStatusText = @"待取件";
        else if (orderModel.orderStatus.integerValue == 3) orderStatusText = @"待配送";
        else if (orderModel.orderStatus.integerValue == 4) orderStatusText = @"已完成";
        TJMOrderDetailInfoModel *orderStatus = [self setInfoWithTitle:@"订单状态" detail:orderStatusText isTel:NO];
        
        NSString *payStatusString;
        if (orderModel.payStatus.integerValue == 0) payStatusString = @"未支付";
        else if (orderModel.payStatus.integerValue == 1) payStatusString = @"已支付";
        TJMOrderDetailInfoModel *payStatus = [self setInfoWithTitle:@"支付详情" detail:payStatusString isTel:NO];
        //订单金额
        NSString *orderMoneyString = [NSString stringWithFormat:@"￥%@",orderModel.orderMoney];
        TJMOrderDetailInfoModel *orderMoney = [self setInfoWithTitle:@"订单金额" detail:orderMoneyString isTel:NO];
        orderMoney.isBigerFont = YES;
        NSArray *orderInfo = @[objValue,objType,objWeight,orderNo,orderStatus,payStatus,orderMoney];
        self.data = @[consignerArr,receiverArr,orderInfo];
    }
    
    return self;
}


- (TJMOrderDetailInfoModel *)setInfoWithTitle:(NSString *)title detail:(NSString *)detail isTel:(BOOL)isTel {
    TJMOrderDetailInfoModel *model = [[TJMOrderDetailInfoModel alloc]init];
    model.title = title;
    model.detail = detail;
    model.isTel = isTel;
    return model;
}

@end
